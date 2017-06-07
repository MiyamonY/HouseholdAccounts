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
        button class:{"ui", "positive", "basic", "button"}, type:"button", id:"detail-correct", name:"correct", "修正"
        button class:{"ui", "negative", "basic", "button"}, type:"button", id:"detail-delete", name:"delete", "削除"

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
      if @messages
        for message in *@messages
          @create_message message
      element "table", class:{"ui", "sortable", "unstackable", "celled", "table"}, ->
        thead ->
          tr ->
            th class:{"center"}, "支払い日"
            th class:{"center"}, "項目"
            th class:{"center"}, "金額"
        tbody id:"table-body", ->
          for account in *@accounts\get_page 1
            tr ->
              td class:{"center"}, ->
                text account.date
                a class:{"ui", "mini", "blue", "label", "detail"}, ["data-value"]:"#{account.id}", "info"
              td class:{"center"}, account.kind
              td class:{"center"}, "￥ #{account.amount}"
        tfoot ->
          tr ->
            th colspan:"3", ->
              div class:{"ui", "right", "floated", "pagination", "menu"}, ->
                a class:{"icon", "item"}, id:"left-page", ["data-value"]:"1", ->
                  i class:{"left", "chevron", "icon"}
                for i = 1, @accounts\num_pages!
                  a class:{"item", (if i == 1 then "active" else ""), "page-button"}, ["data-value"]:"#{i}", "#{i}"
                a class:{"icon", "item"}, id:"right-page", ["data-value"]:"#{@accounts\num_pages!}", ->
                  i class:{"right", "chevron", "icon"}
      @create_detail_modal!
      @create_delete_modal!

      form method:"post", id:"form"

    @content_for "tail_scripts", ->
      script src:"/static/list.js"
