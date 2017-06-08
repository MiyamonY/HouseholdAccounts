lapis = require "lapis"
db = require "lapis.db"

import respond_to from require "lapis.application"
import Accounts, Kinds, Members, Tags from require "models"
import AccountMessage from require "views.util.message"
import Line from require "line"
import map from require "util"

class Account extends lapis.Application
  @path: "/account"
  @name: "account_"

  [list: "/list"]:  respond_to {
    GET: =>
      @page_title = "入出金一覧"
      @accounts = Accounts\paginated [[order by date desc]], {per_page:10,
        prepare_results: (accounts) ->
          map accounts, (account) -> account\to_json_data!
      }
      @messages =  @session.messages
      @session.messages = nil
      render: "account.list"

    POST: =>
      if @params.delete
        account = Accounts\find @params.delete
        account\delete!
        message = AccountMessage(AccountMessage.types.delete, "削除", account)
        @session.messages = {message\for_session!}
        line = Line message
        line\notify_to Members.send_notification!
        redirect_to: @url_for("account_list")
      elseif @params.correct
        return redirect_to: @url_for("account_correct", id: @params.correct)
      else
        @write status:404, "account(no.#{id}) not found"
  }

  [correct: "/correct/:id[%d]"]: respond_to {
    before: =>
      id = @params.id
      @account = Accounts\find id
      @write status:404, "account(no.#{id}) not found" unless @account

    GET: =>
      @page_title = "出入金修正"
      @kinds = Kinds\select!
      @members = Members\select!
      @tags = Tags\select!
      render: "account.correct"

    POST: =>
      @account.type = @params.type
      @account.date = @params.date
      @account.member_id = @params.member
      @account.kind_id = @params.kind
      @account.amount = @params.amount
      @account.etc = @params.etc or ""
      @account\update "type", "date", "member_id", "kind_id", "amount", "etc"
      message = AccountMessage(AccountMessage.types.correct, "修正", @account)
      @session.messages = {message\for_session!}
      line = Line message
      line\notify_to Members.send_notification!
      redirect_to: @url_for "account_list"
  }

  [input: "/input"]: respond_to {
  GET: =>
    @page_title = "出金入力"
    @kinds = Kinds\select!
    @members = Members\select!
    @tags = Tags\select!
    render: "account.input"

  POST: =>
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
    @session.messages = {message\for_session!}
    line = Line message
    line\notify_to Members.send_notification!
    redirect_to: @url_for "account_list"
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
