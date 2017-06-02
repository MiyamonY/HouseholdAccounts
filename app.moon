lapis = require "lapis"
db = require "lapis.db"
util = require "lapis.util"

import respond_to from require "lapis.application"
import Accounts, Kinds, Members from require "models"

class extends lapis.Application
  layout: require "views.layout"
  [index: "/"]: =>
    @page_title = "トップ"
    render: true

  [list: "/list"]:  respond_to {
    GET: =>
      @page_title = "入出金一覧"
      @accounts = Accounts\select!
      print "#{util.to_json(@accounts)}"
      render: true

    POST: =>
      print "#{util.to_json(@params)}"
      if @params.delete
        account = Accounts\find @params.delete
        account\delete!
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
      print "#{util.to_json(@account)}"
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
    redirect_to: @url_for "list"
  }
