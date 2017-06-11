lapis = require "lapis"

import respond_to, capture_errors from require "lapis.application"
import assert_valid from require "lapis.validate"
import Tags from require "models"
import Message from require "views.util.message"
import map from require "util"
import print_as_json from require "util"
import Session from require "controllers.session"

class Tag extends lapis.Application
  @path: "/tag"
  @name: "tag_"

  [list: "/list"]: respond_to {
    GET: =>
      @tags = Tags\select!
      session = Session @session
      @messages = session\pop_messages!
      render: "tag.list"

    POST: capture_errors {
      =>
        assert_valid @params, {
          {"name", "タグ名を入力して下さい", exists:true}
        }

        Tags\create { name:@params.name, color:Tags.colors\for_db "blue" }

        session = Session @session
        session\push_messages {Message("info", "追加", {"追加しました:#{@params.name}"})}
        redirect_to: @url_for "tag_list"

      on_error: =>
        session = Session @session
        session\push_messages {Message(Message.types.validation_error, "エラー", @errors)}
        print_as_json msg
        redirect_to: @url_for "tag_list"
    }
  }

  [delete: "/delete"]: respond_to {
    before: =>
      @tag = Tags\find @params.delete
      @write status:404, "tag(no.#{@params.delete}) not found" unless @tag

    POST: =>
      @tag\delete!
      session = Session @session
      session\push_messages {Message("info", "削除", {"削除しました:#{@tag.name}"})}
      redirect_to: @url_for "tag_list"
  }
