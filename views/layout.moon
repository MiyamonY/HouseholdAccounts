import Widget from require "lapis.html"

class Menu
  create_menu: =>
    div class:{"ui", "stackable", "labeled", "icon", "menu"}, ->
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

class Head
  component_path: "/static/components"

  create_head: =>
    title @page_title or "Household Account"
    meta charset:"UTF-8"
    meta name:"viewport", content:"width=device-width, initial-scale=1.0, maximum-scale=1.0"
    link rel:"stylesheet", type:"text/css", href:"#{@component_path}/semantic/dist/semantic.min.css"
    link rel:"stylesheet", type:"text/css", href:"#{@component_path}/semantic-ui-calendar/dist/calendar.min.css"
    link rel:"stylesheet", type:"text/css", href:"/static/common.css"
    script src:"#{@component_path}/jquery/dist/jquery.min.js"
    script src:"#{@component_path}/semantic/dist/semantic.min.js"
    script src:"#{@component_path}/semantic-ui-calendar/dist/calendar.min.js"
    script src:"#{@component_path}/jquery-tablesort/jquery.tablesort.min.js"
class Layout extends Widget
  @include Menu
  @include Head

  content: =>
    html_5 lang:"ja", ->
      head ->
        @create_head!
      body ->
        @create_menu!

        div class:{"ui", "grid", "container"}, ->
          @content_for "inner"
        @content_for "tail_scripts"
        script src:"/static/common.js"
