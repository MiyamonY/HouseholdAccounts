import Widget from require "lapis.html"
import DeleteModal from require "views.util.delete_modal"
import MessageWidget from require "views.util.message"
import Tags from require "models"

class TagAddModalWidget
  creat_tag_add: (colors, color)=>
    div class:{"ui", "small", "modal"}, id:"tag-add", ->
      div class:{"header"}, "タグ追加"
      div class:{"content"}, ->
        form class:{"ui", "form"}, method:"post", id:"tag-add-form", ->
          div class:{"required", "field"}, ->
            label "タグ名"
            input name:"name", type:"text", placeholder:"店名等"
          div class:{"required", "field"}, ->
            label "タグ色"
            div class:{"ui", "selection", "dropdown"}, ->
              input name:"color", type:"hidden", value:color
              i class:{"dropdown", "icon"}
              div class:{"default", "text"}, "タグの色"
              div class:"menu", ->
                for color, id in pairs colors
                  if (type id)  == "number"
                    element "div", {["class"]:"item", ["data-value"]:id}, ->
                      text color
                      div class:{"ui", color, "empty", "mini", "circular", "label"}
          div class:{"actions"}, ->
            div class:{"ui", "error", "message"}
            button class:{"ui", "positive", "basic", "button"}, type:"submit", "追加"
            div class:{"ui", "negative",  "basic", "button"}, "キャンセル"

class TagCorrectModalWidget
  create_tag_correct: (colors)=>
    div class:{"ui", "small", "modal"}, id:"tag-correct", ->
      div class:{"header"}, "タグ修正"
      div class:{"content"}, ->
        form class:{"ui", "form"}, method:"post", id:"tag-correct-form", action:@url_for("tag_correct"), ->
          input type:"hidden", id:"tag-id", name:"id", value:""
          div class:{"required", "field"}, ->
            label "タグ名"
            input name:"name", type:"text", placeholder:"店名等", id:"tag-name"
          div class:{"required", "field"}, ->
            label "タグ色"
            div class:{"ui", "selection", "tag-color", "dropdown"}, id:"tag-color-dropdown", ->
              input name:"color", type:"hidden"
              i class:{"dropdown", "icon"}
              div class:{"default", "text"}, "タグの色"
              div class:"menu", ->
                for color, id in pairs colors
                  if (type id)  == "number"
                    element "div", {["class"]:"item", ["data-value"]:id}, ->
                      text color
                      div class:{"ui", color, "empty", "mini", "circular", "label"}
          div class:{"actions"}, ->
            div class:{"ui", "error", "message"}
            button class:{"ui", "positive", "basic", "button"}, type:"submit", "修正"
            div class:{"ui", "negative",  "basic", "button"}, "キャンセル"

class List extends Widget
  @include DeleteModal
  @include MessageWidget
  @include TagAddModalWidget
  @include TagCorrectModalWidget

  content: =>
    @content_for "inner", ->
      h1 class:{"ui", "header"}, ->
        text "タグ編集"
        a class:{"ui", "teal", "circular", "huge", "label"}, id:"tag-add-show", ->
          i class:{"plus", "fitted", "icon"}
      @create_message @messages
      form method:"post", id:"form", action:@url_for("tag_delete"), ->
        element "table", class:{"ui", "sortable", "unstackable", "celled", "striped", "table"}, ->
          thead ->
            tr ->
              th class:{"center"}, "店名等"
              th class:{"center"}, "操作"
          tbody ->
            if @tags
              for tag in *@tags
                tr ->
                  td class:{"center"}, ->
                    span ["data-value"]:"#{tag.name}", id:"tag-name-#{tag.id}", "#{tag.name}"
                    div class:{"ui", "#{tag\to_color!}", "empty", "circular", "label"}, id:"tag-color-#{tag.id}", ["data-value"]:"#{tag.color}"
                  td class:{"center"}, ->
                    button class:{"ui", "positive", "button"}, type:"button", name:"correct", value:"#{tag.id}", "修正"
                    button class:{"ui", "negative", "button"}, type:"button", name:"delete", value:"#{tag.id}", "削除"
      @create_delete_modal!
      @creat_tag_add @colors, @colors["white"]
      @create_tag_correct @colors

    @content_for "tail_scripts", ->
      script src:"/static/tag_list.js"
