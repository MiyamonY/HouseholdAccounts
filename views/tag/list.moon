import Widget from require "lapis.html"
import DeleteModal from require "views.util.delete_modal"
import MessageWidget from require "views.util.message"

class List extends Widget
  @include DeleteModal
  @include MessageWidget

  content: =>
    @content_for "inner", ->
      h1 class:{"ui", "header"}, ->
        text "タグ編集"
        a class:{"ui", "teal", "circular", "huge", "label"}, href:@url_for("tag_create"), "+"
      if @messages
        for message in *@messages
          @create_message message
      form method:"post", id:"form", ->
        element "table", class:{"ui", "sortable", "unstackable", "celled", "table"}, ->
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

    @content_for "tail_scripts", ->
      script src:"/static/tag_list.js"
