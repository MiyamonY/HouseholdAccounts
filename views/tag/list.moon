import Widget from require "lapis.html"
import DeleteModal from require "views.util.delete_modal"
import MessageWidget from require "views.util.message"

class TagAddModalWidget
  creat_tag_add: =>
    div class:{"ui", "small", "modal"}, id:"tag-add", ->
      div class:{"header"}, "タグ追加"
      div class:{"content"}, ->
        form class:{"ui", "form"}, method:"post", id:"tag-add-form", ->
          div class:{"required", "field"}, ->
            label "タグ名"
            input name:"name", type:"text", placeholder:"店名等"
          div class:{"actions"}, ->
            div class:{"ui", "error", "message"}
            button class:{"ui", "positive", "basic", "button"}, type:"submit", "追加"
            div class:{"ui", "negative",  "basic", "button"}, "キャンセル"

class List extends Widget
  @include DeleteModal
  @include MessageWidget
  @include TagAddModalWidget

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
                  td class:{"center"}, tag.name
                  td class:{"center"}, ->
                    button class:{"ui", "negative", "button"}, type:"button", name:"delete", value:"#{tag.id}", "削除"
      @create_delete_modal!
      @creat_tag_add!

    @content_for "tail_scripts", ->
      script src:"/static/tag_list.js"
