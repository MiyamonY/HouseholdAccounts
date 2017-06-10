import Widget from require "lapis.html"
import MessageWidget from require "views.util.message"

class Create extends Widget
  @include MessageWidget

  content: =>
    h1 class:{"header"}, "メンバー追加"
    @create_message @messages
    form class:{"ui", "form"}, method:"post", ->
      div class:{"required", "field"}, ->
        label "名前"
        input name:"name", type:"text"
      div class:{"field"}, ->
        label "トークン"
        input name:"token", type:"text"
      div class:{"field"}, ->
        div class:{"ui", "toggle", "checkbox"}, ->
          input name:"send", type:"checkbox"
          label "通知する"
      div class:{"ui", "error", "message"}
      button class:{"ui", "positive", "basic", "button"}, type:"submit", "追加"
      a class:{"ui", "negative", "basic", "button"}, href:@url_for("member_list"), "戻る"

    @content_for "tail_scripts", ->
      script src:"/static/member_create.js"
