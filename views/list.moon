import Widget from require "lapis.html"

class List extends Widget
  content: =>
    h1 class:{"header"}, "入出金一覧"
    element "table", class:{"ui", "celled", "table"}, ->
      thead ->
        tr ->
          th "日付"
          th "項目"
          th "支払い者"
          th "金額"
          th "その他"
          th ""
      tbody ->
        for account in *@accounts
          tr ->
            td account.date
            td account\get_kind!.kind
            td account\get_member!.member
            td "￥ #{account.amount}"
            td account.etc
            td ""
      tfoot ->
        tr ->
          th colspan:"6", ->
            div class:{"ui", "right", "floated", "pagination", "menu"}, ->
              a class:{"icon", "item"}, ->
                i class:{"left", "chevron", "icon"}
              a class:{"item"}, "1"
              a class:{"item"}, "2"
              a class:{"item"}, "3"
              a class:{"item"}, "4"
              a class:{"icon", "item"}, ->
                i class:{"right", "chevron", "icon"}
