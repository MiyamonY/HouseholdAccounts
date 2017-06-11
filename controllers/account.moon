lapis = require "lapis"
db = require "lapis.db"

import respond_to, capture_errors from require "lapis.application"
import assert_valid from require "lapis.validate"
import Accounts, Kinds, Members, Tags from require "models"
import Message, AccountMessage from require "views.util.message"
import Line from require "line"
import map from require "util"
import print_as_json from require "util"
import Session from require "controllers.session"

class Account extends lapis.Application
  @path: "/account"
  @name: "account_"

  find_account: (request, id) ->
    request.account = Accounts\find id
    request.write status:404, "account(no.#{id}) not found" unless request.account

  notify_to_line: (message) ->
    line = Line message
    line\notify_to Members.send_notification!

  validation_input: (params) ->
    assert_valid params, {
      {"date", "日付を入力して下さい", exists:true}
      {"member", "支払い者を入力して下さい", exists:true, is_integer:true}
      {"kind", "項目を入力して下さい", exists:true, is_integer:true}
      {"amount", "金額を入力して下さい", exists:true, is_integer:true}
    }

  [list: "/list"]: =>
    @page_title = "入出金一覧"
    @accounts = Accounts\paginated [[order by date desc]], {per_page:10,
      prepare_results: (accounts) ->
        map accounts, (account) -> account\to_json_data!
    }
    session = Session @session
    @messages = session\pop_messages!
    render: "account.list"

  [input: "/input"]: respond_to {
    GET: =>
      @page_title = "出金入力"
      @kinds = Kinds\select!
      @members = Members\select!
      @tags = Tags\select!
      session = Session @session
      @messages = session\pop_messages!
      render: "account.input"

    POST: capture_errors {
      =>
        Account.validation_input @params

        account = Accounts\create {
          type: Accounts.types.payment
          date: @params.date
          member_id: @params.member
          kind_id: @params.kind
          amount: @params.amount
          etc: @params.etc or ""
          input_date: db.format_date!
        }

        message = AccountMessage(AccountMessage.types.add, "追加", account)
        session = Session @session
        session\push_messages {message}
        Account.notify_to_line message
        redirect_to: @url_for "account_list"

      on_error: =>
        session = Session @session
        session\push_messages {Message(Message.types.validation_error, "エラー", {@errors})}
        redirect_to: @url_for "account_input"
    }
  }

  [correct: "/correct/:id[%d]"]: respond_to {
    before: =>
      Account.find_account @, @params.id

    GET: =>
      @page_title = "出入金修正"
      @kinds = Kinds\select!
      @members = Members\select!
      @tags = Tags\select!
      session = Session @session
      @messages = session\pop_messages!
      render: "account.correct"

    POST: capture_errors {
      =>
        Account.validation_input @params

        @account\update {
          type: @params.type
          date: @params.date
          member_id: @params.member
          kind_id: @params.kind
          amount: @params.amount
          etc: @params.etc or ""
        }

        message = AccountMessage(AccountMessage.types.correct, "修正", @account)
        session = Session @session
        session\push_messages {message}
        Account.notify_to_line message
        redirect_to: @url_for "account_list"

      on_error: =>
        session = Session @session
        session\push_messages {Message(Message.types.validation_error, "エラー", @errors)}
        redirect_to: @url_for "account_correct", id:@params.id
    }
  }

  [delete: "/delete"]: respond_to {
    before: =>
      Account.find_account @, @params.delete

    POST: =>
      @account\delete!
      message = AccountMessage(AccountMessage.types.delete, "削除", @account)
      session = Session @session
      session\push_messages {message}
      Account.notify_to_line message
      redirect_to: @url_for("account_list")
  }


  "/account": =>
    id = @req.params_get.id
    account = Accounts\find id
    json: account\to_json_data!

  "/accounts": =>
    account_page = Accounts\paginated [[order by date desc]], {per_page:10,
        prepare_results: (accounts) ->
          map accounts, (account) -> account\to_json_data!
    }
    page = @req.params_get.page
    accounts = account_page\get_page if page then page else 1
    json: accounts

  "/accounts/sum": =>
    params = @req.params_get
    this = os.date "*t"
    from_ = params["from"] or this.year
    to = params["to"] or this.year
    data = {}
    for year = from_, to
      amounts = {}
      for month = 1, 12
        accounts = Accounts\select_by_date year, month
        table.insert(amounts, Accounts.sum_up_amounts(accounts))
      table.insert(data, {["year"]:year, ["amounts"]:amounts})
    json: data
