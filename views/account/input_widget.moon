class AccountInputWidget
  create_account_input: (members, tags, date="", member="", kind="", amount="", etc="") =>
    form class:{"ui", "form"}, method:"post", ->
      div class:{"required", "field"}, ->
        label "日付"
        div class:{"ui", "calendar"}, id:"date", ->
          div class:{"ui", "input", "left", "icon"}, ->
            i class:{"calendar", "icon"}
            input name:"date", type:"text", placeholder:"支払い日", value:date
      div class:{"required", "field"}, ->
        label "支払い者"
        div class:{"ui", "selection", "dropdown"}, ->
          input name:"member", type:"hidden", value:member
          i class:{"dropdown", "icon"}
          div class:{"default", "text"}, "誰が払ったか"
          div class:"menu", ->
            for member in *members
              unless member.deleted
                element "div", {["class"]:"item", ["data-value"]:member.id}, member.member
      div class:{"required", "field"}, ->
        label "項目"
        div class:{"ui", "selection", "dropdown"}, ->
          input name:"kind", type:"hidden", value:kind
          i class:{"dropdown", "icon"}
          div class:{"default", "text"}, "何に使ったか"
          div class:"menu", ->
            for kind in *@kinds
              element "div", {["class"]:"item", ["data-value"]:kind.id}, kind.kind
      div class:{"required", "field"}, ->
          label "金額(円)"
          div class:{"ui", "rigth", "labeled", "input"}, ->
            div class:{"ui", "label"}, "￥"
            input name:"amount", type:"number", placeholder:"金額", value:amount
      div class:{"field"}, ->
          label "その他"
          input name:"etc", type:"text", id:"etc", placeholder:"店名など", value:etc
          if @tags
            div class:{"ui", "tag", "mini", "labels"}, ->
              for tag in *tags
                a href:"#etc", ->
                  div class:{"ui", "#{tag.color}", "label"}, ["data-value"]:"#{tag.name}", "#{tag.name}"
      div class:{"field"}, ->
        div class:{"ui", "error", "message"}
        button class:{"ui", "positive", "basic", "button"}, type:"submit", "追加"
        a class:{"ui", "negative", "basic", "button"}, href:@url_for("account_list"), "戻る"

{:AccountInputWidget}
