import Widget from require "lapis.html"
import DeleteModal from require "views.util.delete_modal"
import MessageWidget from require "views.util.message"

class List extends Widget
  @include DeleteModal
  @include MessageWidget

  content: =>
    @content_for "inner", ->
      h1 class:{"header"}, ->
        text "メンバー一覧"
        a class:{"ui", "teal", "circular", "huge", "label"}, href:@url_for("member_create"), "+"
      if @messages
        for message in *@messages
          @create_message message
      form method:"post", id:"form", ->
        element "table", class:{"ui", "sortable", "unstackable", "celled", "table"}, ->
          thead ->
            tr ->
              th class:{"center"}, "名前"
              th class:{"center"}, "トークン"
              th class:{"center"}, "操作"
          tbody ->
            if @members
              for member in *@members
                unless member.deleted
                  tr ->
                    td class:{"center"}, member.member
                    td class:{"center"}, if member.token == "" then "empty" else "ok"
                    td class:{"center"}, ->
                      a class:{"ui", "positive", "button"}, href:@url_for("member_correct", id:member.id), "修正"
                      button class:{"ui", "disabled", "negative", "button"}, type:"button", name:"delete", disabled:true, value:"#{member.id}", "削除"
      @create_delete_modal!

    @content_for "tail_scripts", ->
      script src:"/static/member_list.js"
