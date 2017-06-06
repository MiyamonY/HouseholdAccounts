lapis = require "lapis"
db = require "lapis.db"
util = require "lapis.util"

import respond_to from require "lapis.application"
import Members from require "models"
import Message from require "views.util.message"

class Member extends lapis.Application
  @path: "/member"
  @name: "member_"

  [list: "/list"]: respond_to {
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

  [create: "/create"]: respond_to {
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

  [correct: "/correct/:id[%d]"]: respond_to {
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