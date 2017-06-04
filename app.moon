lapis = require "lapis"
db = require "lapis.db"
util = require "lapis.util"

import respond_to from require "lapis.application"
import Accounts, Kinds, Members, Tags from require "models"
import Message from require "views.util.message"

class extends lapis.Application
  layout: require "views.layout"
  @include "controllers.tag"
  @include "controllers.account"

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

  [member_list: "/member/list"]: respond_to {
    GET: =>
      @members = Members\select!
      @messages =  @session.messages
      @session.messages = nil
      render: "member.list"

    POST: =>
      if @params.delete
        member = Members\find @params.delete
        member.deleted = db.TRUE
        member\update "deleted"
        @session.messages = {Message("info", "削除", {"削除しました:#{member.member}"})}
      redirect_to: @url_for "member_list"
  }

  [member_create: "/member/create"]: respond_to {
    GET: =>
      render: "member.create"

    POST: =>
      Members\create {
        member: @params.name
        token: if @params.token then @params.token else nil
        color: 0
        deleted: db.FALSE
      }
      @session.messages = {Message("info", "追加", {"追加しました:#{@params.name}"})}
      redirect_to: @url_for "member_list"
  }

  [member_correct: "/member/correct/:id[%d]"]: respond_to {
    before: =>
      id = @params.id
      @member = Members\find id
      @write status:404, "member(no.#{id}) not found" unless @member

    GET: =>
      render: "member.correct"

    POST: =>
      @member.token = @params.token
      @member\update "token"
      @session.messages = {Message("info", "修正", {"修正しました:#{@params.token}"})}
      redirect_to: @url_for "member_list"
  }
