import Widget from require "lapis.html"

class Input extends Widget
  content: =>
    h1 class: "header", "出金入力"
    form class:{"ui", "form"}, method:"post", ->
      div class:{"field"}, ->
        label "日付"
        input name:"date", type:"date"
      div class:{"field"}, ->
        lable "項目"
        input name:"kind", type:"text"
      div class:{"field"}, ->
        label "支払い"
        div class:{"ui", "selection", "dropdown"}, ->
          input name:"who", type:"hidden"
          i class:{"dropdown", "icon"}
          div class:{"default", "text"}, "支払い"
          div class:"menu", ->
            element "div", {["class"]:"item", ["data-value"]:"0"}, "洋平"
            element "div", {["class"]:"item", ["data-value"]:"1"}, "あゆみ"
      div class:{"field"}, ->
        label "金額(円)"
        input name:"amounts", type:"number"
      button class:{"ui", "button"}, type:"submit", "確定"
