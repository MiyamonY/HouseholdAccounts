import Widget from require "lapis.html"
import AccountInputWidget from require "views.account.input_widget"
import MessageWidget from require "views.util.message"

class Input extends Widget
  @include AccountInputWidget
  @include MessageWidget

  content: =>
    @content_for "inner", ->
      h1 class: "header", "お金入力"
      @create_message @messages
      @create_account_input @members, @tags

      @content_for "tail_scripts", ->
        script src:"/static/input.js"
