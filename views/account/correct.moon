import Widget from require "lapis.html"
import AccountInputWidget from require "views.account.input_widget"
import MessageWidget from require "views.util.message"

class Correct extends Widget
  @include AccountInputWidget
  @include MessageWidget

  content: =>
    @content_for "inner", ->
      h1 class: "header", "使ったお金(修正)"
      @create_message @messages
      @create_account_input @members, @tags, @account.date, @account.member_id,
        @account.kind_id, @account.amount, @account.etc

      @content_for "tail_scripts", ->
        script src:"/static/input.js"
