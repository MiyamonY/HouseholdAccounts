import Widget from require "lapis.html"

class Create extends Widget
  content: =>
    h1 class:{"header"}, "タグ追加"
    form class:{"ui", "form"}, method:"post", ->
      div class:{"required", "field"}, ->
        label "タグ名"
        input name:"name", type:"text", placeholder:"店名等"
      button class:{"ui", "positive", "basic", "button"}, type:"submit", "追加"
      a class:{"ui", "negative", "basic", "button"}, href:@url_for("tag_list"), "戻る"
