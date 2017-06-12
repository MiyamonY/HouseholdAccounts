import Widget from require "lapis.html"
import DeleteModal from require "views.util.delete_modal"
import MessageWidget from require "views.util.message"

class DetailModal
  create_detail_modal: =>
    div class:{"ui", "small", "modal"}, id:"detail-modal", ->
      div class:{"header"}, "詳細"
      div class:{"content"}, ->
        element "table", class:{"ui", "unstackable", "definition", "table"}, ->
          tbody ->
            tr ->
              td class:{"center"}, "支払い日"
              td class:{"center"}, id:"detail-date"
            tr ->
              td class:{"center"}, "項目"
              td class:{"center"}, id:"detail-kind"
            tr ->
              td class:{"center"}, "金額"
              td class:{"center"}, id:"detail-amount"
            tr ->
              td class:{"center"}, "担当"
              td class:{"center"}, id:"detail-member"
            tr ->
              td class:{"center"}, "その他"
              td class:{"center"}, id:"detail-etc"
            tr ->
              td class:{"center"}, "入力日"
              td class:{"center"}, id:"detail-input-date"
      div class:{"actions"}, ->
        button class:{"ui", "positive", "basic", "button"}, type:"button", id:"detail-correct", value:"", "修正"
        button class:{"ui", "negative", "basic", "button"}, type:"button", id:"detail-delete", value:"", name:"delete", "削除"

class List extends Widget
  @include DetailModal
  @include DeleteModal
  @include MessageWidget

  content: =>
    @content_for "inner", ->
      h1 class:{"ui", "header"}, ->
        text "使ったお金一覧"
        a class:{"ui", "teal", "circular", "huge", "label"}, href:@url_for("account_input"), ->
          i class:{"plus", "fitted", "icon"}
      @create_message @messages
      div class:{"ui", "basic", "segment"}, ->
        div class:{"ui", "right", "floated", "mini", "teal", "buttons"}, ->
          div class:{"ui", "right", "page", "button"}, "表示数"
          for i in *{10, 20, 50, 100}
            div class:{"ui", "right", "clickable", "page", "button", if i == 10 then "active" else ""}, ["data-value"]:"#{i}", "#{i}"
      div class:{"ui", "basic", "segment"}, ->
        div class:{"ui", "active","loader"}, id:"table-loader"
        element "table", class:{"ui", "sortable", "unstackable", "celled", "table"}, ->
          thead ->
            tr ->
              th class:{"center"}, "支払い日"
              th class:{"center"}, "項目"
              th class:{"center"}, "金額"
          tbody id:"table-body"
          tfoot ->
            tr ->
              th colspan:"3", id:"pagination-menu"
      @create_detail_modal!
      @create_delete_modal!

      form method:"post", id:"delete-form", action:"/account/delete"

    @content_for "tail_scripts", ->
      script src:"/static/list.js"
