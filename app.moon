lapis = require "lapis"
db = require "lapis.db"
util = require "lapis.util"

import respond_to from require "lapis.application"
import Accounts, Kinds, Members from require "models"

class Message
  new: (type, head, message) =>
    @type = type
    @head = head
    @message = message

class extends lapis.Application
  layout: require "views.layout"
  [index: "/"]: =>
    @page_title = "トップ"
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
    render: true

  POST: =>
    db.insert "accounts", {
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
