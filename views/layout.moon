import Widget from require "lapis.html"

class Menu
  menu: =>
    div class:{"ui", "labeled", "icon", "menu"}, ->
      div class:{"header", "item"}, ""
      a class:{"item"}, href:@url_for("index"), ->
        i class:{"home", "icon"}
        text "トップ"
      a class:{"item"}, href:@url_for("list"), ->
        i class:{"list", "icon"}
        text "入出金一覧"
      a class:{"item"}, href:@url_for("input"), ->
        i class:{"shop", "icon"}
        text "出金入力"


class Layout extends Widget
  @include Menu

  content: =>
    html_5 lang:"ja", ->
      head ->
        title @page_title or "Household Account"
        meta charset:"UTF-8"
        link rel:"stylesheet", type:"text/css", href:"static/Semantic-UI-CSS-master/semantic.min.css"
        script src:"https://code.jquery.com/jquery-3.1.1.min.js",
          integrity:"sha256-hVVnYaiADRTO2PzUGmuLJr8BLUSjGIZsDYGmIJLv2b8=",
          crossorigin:"anonymous"
        script src:"static/Semantic-UI-CSS-master/semantic.min.js"
      body ->
        @menu!

        div class:{"ui", "container"}, ->
          @content_for "inner"
