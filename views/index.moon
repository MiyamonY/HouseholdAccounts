import Widget from require "lapis.html"

class Input extends Widget
  content: =>

    @content_for "inner", ->
      h1 class: {"h1"}, "家計簿"
      div class: {"ui","cards"}, ->
        div class:{"red card"}, ->
          a class:{"content"}, href:@url_for("list"), ->
            div class:{"header"}, "入出金一覧"
            div class:{"meta"}, ""
            div class:{"description"}, "入出金を一覧で閲覧できます"
        div class:{"orange card"}, ->
          a class:{"content"}, href:@url_for("input"), ->
            div class:{"header"}, "出金入力"
            div class:{"meta"}, ""
            div class:{"description"}, "出金を入力します"
