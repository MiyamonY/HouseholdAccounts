import Widget from require "lapis.html"

class Menu
  create_menu: =>
    div class:{"ui", "stackable",  "menu"}, ->
      div class:{"ui", "container"}, ->
        a class:{"header", "item"}, href:@url_for("index"), ->
          i class:{"shopping bag", "icon"}
          text "家計簿"
        a class:{"item"}, href:@url_for("account_list"), ->
          i class:{"list", "icon"}
          text "使ったお金"
        div class:{"ui", "dropdown", "item"}, ->
          i class:{"settings", "icon"}
          text "設定"
          i class:{"dropdown", "icon"}
          div class:{"menu"}, ->
            a class:{"item"}, href:@url_for("member_list"), "メンバー編集"
            a class:{"item"}, href:@url_for("tag_list"), "タグ編集"

class Head
  component_path: "/static/components"

  create_head: =>
    title @page_title or "Household Account"
    meta charset:"UTF-8"
    meta name:"viewport", content:"width=device-width, initial-scale=1.0, maximum-scale=1.0"
    link rel:"stylesheet", type:"text/css", href:"#{@component_path}/semantic/dist/semantic.min.css"
    link rel:"stylesheet", type:"text/css", href:"#{@component_path}/semantic-ui-calendar/dist/calendar.min.css"
    link rel:"stylesheet", type:"text/css", href:"/static/common.css"
    @content_for "extra_csses"
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

        div class:{"ui", "main", "text", "container"}, ->
          @content_for "inner"
        @content_for "tail_scripts"
        script src:"/static/common.js"
