import Widget from require "lapis.html"

class Correct extends Widget

  content: =>
    h1 class:{"header"}, "メンバー修正"
    form class:{"ui", "form"}, method:"post", ->
      div class:{"required", "field"}, ->
        label "名前"
        input type:"text", value:"#{@member.member}", readonly:true
      div class:{"field"}, ->
        label "トークン"
        input name:"token", value:"#{@member.token}", type:"text"
      button class:{"ui", "positive", "basic", "button"}, type:"submit", "修正"
      a class:{"ui", "negative", "basic", "button"}, href:@url_for("member_list"), "戻る"