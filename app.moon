lapis = require "lapis"
db = require "lapis.db"

import respond_to from require "lapis.application"
import Accounts, Kinds, Members from require "models"

class extends lapis.Application
  layout: require "views.layout"
  [index: "/"]: =>
    @page_title = "トップ"
    render: true
  [list: "/list"]: =>
    @page_title = "入出金一覧"
    @accounts = Accounts\find_all [i for i = 1, Accounts\count!]
    render: true
  [input: "/input"]: respond_to {
  GET: =>
    @page_title = "出金入力"
    @kinds = Kinds\find_all [ i for i = 1,Kinds\count!]
    @members = Members\find_all [ i for i= 1,Members\count!]
    render: true

  POST: =>
    db.insert "accounts", {
      type: Accounts.types.payment
      date: @params.date
      member_id: @params.member
      kind_id: @params.kind
      amount: @params.amount
      etc: @params.etc or ""
    }
    redirect_to: @url_for "list"
  }
