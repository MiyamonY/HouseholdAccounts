import Widget from require "lapis.html"

class List extends Widget
  content: =>
    @content_for "inner", ->
      h1 class:{"ui", "header"}, ->
        text "タグ編集"
        a class:{"ui", "teal", "circular", "huge", "label"}, href:@url_for("tag_create"), "+"
      form method:"post", ->
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
                    button class:{"ui", "negative", "button"}, type:"submit", name:"delete", value:"#{tag.id}", "削除"
