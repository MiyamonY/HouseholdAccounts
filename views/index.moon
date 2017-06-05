import Widget from require "lapis.html"

class Input extends Widget
  content: =>
    @content_for "extra_csses", ->
      link rel:"stylesheet", type:"text/css", href:"/static/index.css"

    @content_for "inner", ->
      h1 class:{"ui", "header"}, "使用金額"
      div class:{"ui", "two", "large", "statistics"}, ->
        div class:{"statistic"}, ->
          div class:{"label"}, "#{@this.month}月の使用金額"
          div class:"value", ->
            span class:{"mini"}, "￥"
            text "#{@this_total}"
        div class:{"grey", "statistic"}, ->
          div class:{"label"}, "#{@last.month}月の使用金額"
          div class:{"value"}, ->
            span class:{"mini"}, "￥"
            text "#{@last_total}"

      h1 class:{"ui", "header"}, "年間使用金額"
      div id:"plot"
    @content_for "tail_scripts", ->
      script src:"/static/components/plotly/plotly.js"
      script src:"/static/index.js"
