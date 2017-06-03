import Widget from require "lapis.html"

class Create extends Widget
  content: =>
    h1 class:{"header"}, "メンバー追加"
    form class:{"ui", "form"}, method:"post", ->
      div class:{"required", "field"}, ->
        label "名前"
        input name:"name", type:"text"
      div class:{"field"}, ->
        label "トークン"
        input name:"token", type:"text"
      button class:{"ui", "positive", "basic", "button"}, type:"submit", "追加"
      a class:{"ui", "negative", "basic", "button"}, href:@url_for("member_list"), "戻る"
