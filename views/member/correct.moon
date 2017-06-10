import Widget from require "lapis.html"
import MessageWidget from require "views.util.message"

class Correct extends Widget
  @include MessageWidget

  content: =>
    h1 class:{"header"}, "メンバー修正"
    @create_message @messages
    form class:{"ui", "form"}, method:"post", ->
      div class:{"required", "field"}, ->
        label "名前"
        input type:"text", name:"name", value:"#{@member.member}", readonly:true
      div class:{"field"}, ->
        label "トークン"
        input type:"text", name:"token", value:"#{@member.token}"
      div class:{"field"}, ->
        div class:{"ui", "toggle", "checkbox"}, ->
          if @member.send
            input name:"send", type:"checkbox", checked:""
          else
            input name:"send", type:"checkbox"
          label "通知する"
      div class:{"ui", "error", "message"}
      button class:{"ui", "positive", "basic", "button"}, type:"submit", "修正"
      a class:{"ui", "negative", "basic", "button"}, href:@url_for("member_list"), "戻る"

    @content_for "tail_scripts", ->
      script src:"/static/member_correct.js"
