import Widget from require "lapis.html"

class Correct extends Widget
  content: =>
    @content_for "inner", ->
      h1 class: "header", "出金入力修正"
      form class:{"ui", "form"}, method:"post", ->
        div class:{"field"}, ->
          label "日付"
          div class:{"ui", "calendar"}, id:"date", ->
            div class:{"ui", "input", "left", "icon"}, ->
              i class:{"calendar", "icon"}
              input name:"date", type:"text", placeholder:"支払い日", value:@account.date
        div class:{"field"}, ->
          label "項目"
          div class:{"ui", "selection", "dropdown"}, ->
            input name:"kind", type:"hidden" , value:@account\get_kind!.kind
            i class:{"dropdown", "icon"}
            div class:{"default", "text"}, "何に使ったか"
            div class:"menu", ->
              for kind in *@kinds
                div class:"item", {["data-value"]:kind.id}, kind.kind
        div class:{"field"}, ->
          label "支払い者"
          div class:{"ui", "selection", "dropdown"}, ->
            input name:"member", type:"hidden", value:@account\get_member!.member
            i class:{"dropdown", "icon"}
            div class:{"default", "text"}, "誰が払ったか"
            div class:"menu", ->
              for member in *@members
                div class:{"item"}, {["data-value"]:member.id}, member.member
        div class:{"field"}, ->
          label "金額(円)"
          div class:{"ui", "rigth", "labeled", "input"}, ->
            div class:{"ui", "label"}, "￥"
            input name:"amount", type:"number", placeholder:"金額", value:@account.amount
        div class:{"field"}, ->
          label "その他"
          input name:"etc", type:"text", placeholder:"店名など", value:@account.etc
        button class:{"ui", "positive", "basic", "button"}, type:"submit", "修正"
      script src:"/static/input.js"
