lapis = require "lapis"
db = require "lapis.db"

import respond_to, capture_errors from require "lapis.application"
import assert_valid from require "lapis.validate"
import Members from require "models"
import Message from require "views.util.message"
import print_as_json from require "util"

class Member extends lapis.Application
  @path: "/member"
  @name: "member_"

  validation_check: (params) ->
    assert_valid params, {
      {"name", "名前を入力して下さい", exists:true, type:"string"}
    }

  [list: "/list"]: respond_to {
    GET: =>
      @members = Members\select!
      @messages =  @session.messages
      @session.messages = nil
      render: "member.list"

    POST: =>
      member = Members\delete_by_id @params.delete
      if member
        @session.messages = {Message("info", "削除", {"削除しました:#{member.member}"})\for_session!}
      else
        @session.messages = {Message(Message.types.db_error, "エラー", {"削除に失敗しました"})\for_session!}
      redirect_to: @url_for "member_list"
  }

  [create: "/create"]: respond_to {
    GET: =>
      @messages =  @session.messages
      @session.messages = nil
      render: "member.create"

    POST: capture_errors {
      =>
        Member.validation_check @params

        Members\create {
          member: @params.name
          token: if @params.token then @params.token else nil
          color: 0
          deleted: db.FALSE
          send: if @params.send == "on" then db.TRUE else db.FALSE
        }
        @session.messages = {Message("info", "追加", {"追加しました:#{@params.name}"})\for_session!}
        redirect_to: @url_for "member_list"

      on_error: =>
        @session.messages = {Message(Message.types.validation_error, "エラー", @errors)\for_session!}
        redirect_to: @url_for "member_create"
    }
  }

  [correct: "/correct/:id[%d]"]: respond_to {
    before: =>
      @member = Members\find @params.id
      @write status:404, "member(no.#{@params.id}) not found" unless @member

    GET: =>
      @messages =  @session.messages
      @session.messages = nil
      render: "member.correct"

    POST: capture_errors {
      =>
        Member.validation_check @params

        @member\update {
          token: @params.token
          send: if @params.send == "on" then db.TRUE else db.FALSE
        }

        @session.messages = {Message("info", "修正", {"修正しました:#{@params.token}"})\for_session!}
        redirect_to: @url_for "member_list"

      on_error: =>
        @session.messages = {Message(Message.types.validation_error, "エラー", @errors)\for_session!}
        redirect_to: @url_for("member_correct", id:@params.id)
      }
  }
