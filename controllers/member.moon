lapis = require "lapis"
db = require "lapis.db"

import respond_to, capture_errors from require "lapis.application"
import assert_valid from require "lapis.validate"
import Members from require "models"
import MemberMessage, Message from require "views.util.message"
import Session from require "controllers.session"
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
      session = Session @session
      @messages = session\pop_messages!
      render: "member.list"

    POST: =>
      member = Members\delete_by_id @params.delete
      message = if member
          MemberMessage(Message.types.delete, "削除", member)
        else
          Message(Message.types.db_error, "エラー", {"削除に失敗しました"})
      session = Session @session
      session\push_messages {message}
      redirect_to: @url_for "member_list"
  }

  [create: "/create"]: respond_to {
    GET: =>
      session = Session @session
      @messages = session\pop_messages!
      render: "member.create"

    POST: capture_errors {
      =>
        Member.validation_check @params

        member = Members\create {
          member: @params.name
          token: if @params.token then @params.token else nil
          color: 0
          deleted: db.FALSE
          send: if @params.send == "on" then db.TRUE else db.FALSE
        }

        session = Session @session
        session\push_messages {MemberMessage(Message.types.add, "追加", member)}

        redirect_to: @url_for "member_list"

      on_error: =>
        session = Session @session
        session\push_messages {Message(Message.types.validation_error, "エラー", @errors)}
        redirect_to: @url_for "member_create"
    }
  }

  [correct: "/correct/:id[%d]"]: respond_to {
    before: =>
      @member = Members\find @params.id
      @write status:404, "member(no.#{@params.id}) not found" unless @member

    GET: =>
      session = Session @session
      @messages = session\pop_messages!
      render: "member.correct"

    POST: capture_errors {
      =>
        Member.validation_check @params

        @member\update {
          token: @params.token
          send: if @params.send == "on" then db.TRUE else db.FALSE
        }

        session = Session @session
        session\push_messages {MemberMessage(Message.types.correct, "修正", @member)}

        redirect_to: @url_for "member_list"

      on_error: =>
        session = Session @session
        session\push_messages {Message(Message.types.validation_error, "エラー", @errors)}

        redirect_to: @url_for("member_correct", id:@params.id)
      }
  }
