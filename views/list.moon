import Widget from require "lapis.html"

class List extends Widget
  content: =>
    h1 class: "index", "Hello"
    div class: "body", ->
      text "Welcome to my site!"
      a href:"/", "トップ"
      a href:"/input", "入力"
      a href:"/", "一覧"
