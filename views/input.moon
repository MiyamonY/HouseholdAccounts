import Widget from require "lapis.html"

class Input extends Widget
  content: =>
    @content_for "inner", ->
      h1 class: "header", "出金入力"
      form class:{"ui", "form"}, method:"post", ->
        div class:{"required", "field"}, ->
          label "日付"
          div class:{"ui", "calendar"}, id:"date", ->
            div class:{"ui", "input", "left", "icon"}, ->
              i class:{"calendar", "icon"}
              input name:"date", type:"text", placeholder:"支払い日"
        div class:{"required", "field"}, ->
          label "支払い者"
          div class:{"ui", "selection", "dropdown"}, ->
            input name:"member", type:"hidden"
            i class:{"dropdown", "icon"}
            div class:{"default", "text"}, "誰が払ったか"
            div class:"menu", ->
              for member in *@members
                element "div", {["class"]:"item", ["data-value"]:member.id}, member.member
        div class:{"required", "field"}, ->
          label "項目"
          div class:{"ui", "selection", "dropdown"}, ->
            input name:"kind", type:"hidden"
            i class:{"dropdown", "icon"}
            div class:{"default", "text"}, "何に使ったか"
            div class:"menu", ->
              for kind in *@kinds
                element "div", {["class"]:"item", ["data-value"]:kind.id}, kind.kind
        div class:{"required", "field"}, ->
            label "金額(円)"
            div class:{"ui", "rigth", "labeled", "input"}, ->
              div class:{"ui", "label"}, "￥"
              input name:"amount", type:"number", placeholder:"金額"
        div class:{"field"}, ->
            label "その他"
            input name:"etc", type:"text", id:"etc", placeholder:"店名など"
            if @tags
              div class:{"ui", "tag", "mini", "labels"}, ->
                for tag in *@tags
                  a href:"#etc", ->
                    div class:{"ui", "#{tag.color}", "label"}, ["data-value"]:"#{tag.name}", "#{tag.name}"
        div class:{"field"}, ->
          button class:{"ui", "positive", "basic", "button"}, type:"submit", "追加"
          a class:{"ui", "negative", "basic", "button"}, href:@url_for("index"), "戻る"

      script src:"static/input.js"
