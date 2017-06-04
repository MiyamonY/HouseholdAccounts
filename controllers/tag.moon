lapis = require "lapis"
import respond_to from require "lapis.application"
import Tags from require "models"
import Message from require "views.util.message"
util = require "lapis.util"

class Tag extends lapis.Application
  @path: "/tag"
  @name: "tag_"

  [list: "/list"]: respond_to {
    GET: =>
      @tags = Tags\select!
      @messages =  @session.messages
      @session.messages = nil
      render: "tag.list"
    POST: =>
      print "#{util.to_json(@params)}"
      if @params.delete
        tag = Tags\find @params.delete
        tag\delete!
        @session.messages = {Message("info", "削除", {"削除しました:#{tag.name}"})}
      elseif @params.name
        Tags\create {name:@params.name, color:0}
        @session.messages = {Message("info", "追加", {"追加しました:#{@params.name}"})}
      redirect_to: @url_for "tag_list"
  }
