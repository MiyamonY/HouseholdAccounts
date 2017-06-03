lapis = require "lapis"
db = require "lapis.db"
util = require "lapis.util"

import respond_to from require "lapis.application"
import Accounts, Kinds, Members, Tags from require "models"

class Message
  new: (type, head, message) =>
    @type = type
    @head = head
    @message = message

class extends lapis.Application
  layout: require "views.layout"

  [index: "/"]: =>
    @page_title = "トップ"
    @this = os.date("*t")
    @last = {k, v for k,v in pairs @this}
    print "#{util.to_json(@last)}"
    @last.month -= 1
    if @last.month == 0
      @last.month = 12
      @last.year -= 1
    where = "where EXTRACT(YEAR FROM date) = ? and EXTRACT(MONTH FROM date) = ?"
    accounts = Accounts\select where, @this.year, @this.month
    @this_total = 0
    for account in *accounts
      @this_total += account.amount
    accounts = Accounts\select where, @last.year, @last.month
    @last_total = 0
    for account in *accounts
      @last_total += account.amount
    render: true

  [list: "/list"]:  respond_to {
    GET: =>
      @page_title = "入出金一覧"
      @accounts = Accounts\select!
      @messages =  @session.messages
      @session.messages = nil
      render: true

    POST: =>
      print "#{util.to_json(@params)}"
      if @params.delete
        account = Accounts\find @params.delete
        account\delete!
        @session.messages = {Message("info", "削除", {"削除しました"})}
        redirect_to: @url_for("list")
      elseif @params.correct
        return redirect_to: @url_for("correct", id: @params.correct)
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
      render: true

    POST: =>
      @account.type = @params.type
      @account.date = @params.date
      @account.member_id = @params.member
      @account.kind_id = @params.kind
      @account.amount = @params.amount
      @account.etc = @params.etc or ""
      @account\update
      @session.messages = {Message("info", "修正", {"修正しました"})}
      redirect_to: @url_for "list"
  }

  [input: "/input"]: respond_to {
  GET: =>
    @page_title = "出金入力"
    @kinds = Kinds\select!
    @members = Members\select!
    @tags = Tags\select!
    render: true

  POST: =>
    Accounts\create {
      type: Accounts.types.payment
      date: @params.date
      member_id: @params.member
      kind_id: @params.kind
      amount: @params.amount
      etc: @params.etc or ""
      input_date: db.format_date!
    }
    @session.messages = {Message("info", "追加", {"追加しました"})}
    redirect_to: @url_for "list"
  }

  [tag_list: "/tag/list"]: respond_to {
    GET: =>
      @tags = Tags\select!
      render: "tag.list"
    POST: =>
      if @params.delete
        tag = Tags\find @params.delete
        tag\delete!
      redirect_to: @url_for "tag_list"
  }

  [tag_create: "/tag/create"]: respond_to {
    GET: =>
      render: "tag.create"

    POST: =>
      Tags\create {name:@params.name, color:0}
      redirect_to: @url_for "tag_list"
  }
