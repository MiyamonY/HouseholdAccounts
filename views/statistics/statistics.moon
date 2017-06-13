import Widget from require "lapis.html"

class Statistics extends Widget
  content: =>
    h1 class:{"ui", "header"}, "月毎の支払い金額"
    element "table", class:{"ui", "sortable", "unstackable", "celled", "definition", "table"}, ->
      thead ->
        tr ->
          th class:{"center"}
          for member in *@members
            th class:{"center"}, member
      tbody ->
          for month, amounts in pairs @data
            tr ->
              td class:{"center"}, month
              for member in *@members
                td class:{"center"}, if amounts[member] then "￥ #{amounts[member]}" else "￥ 0"
