import Widget from require "lapis.html"

class List extends Widget
  content: =>
    @content_for "inner", ->
      h1 class:{"header"}, "入出金一覧"
      form class:{"ui", "form"}, method:"post", ->
        element "table", class:{"ui", "sortable", "celled", "table"}, ->
          thead ->
            tr ->
              th "支払い日"
              th "項目"
              th "支払い者"
              th "金額"
              th "その他"
              th "入力日"
              th ""
          tbody ->
            for account in *@accounts
              tr ->
                td account.date
                td account\get_kind!.kind
                td account\get_member!.member
                td "￥ #{account.amount}"
                td account.etc
                td account.input_date
                td ->
                  button class:{"ui", "blue","button"}, type:"submit", name:"correct", value:"#{account.id}", "修正"
                  button class:{"ui", "red","button"}, type:"submit", name:"delete", value:"#{account.id}", "削除"
          tfoot ->
            tr ->
              th colspan:"7", ->
                div class:{"ui", "right", "floated", "pagination", "menu"}, ->
                  a class:{"icon", "item"}, ->
                    i class:{"left", "chevron", "icon"}
                  a class:{"item"}, "1"
                  a class:{"item"}, "2"
                  a class:{"item"}, "3"
                  a class:{"item"}, "4"
                  a class:{"icon", "item"}, ->
                    i class:{"right", "chevron", "icon"}
