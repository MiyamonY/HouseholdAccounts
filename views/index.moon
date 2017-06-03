import Widget from require "lapis.html"

class Input extends Widget
  content: =>

    @content_for "inner", ->
      div class:{"ui", "two", "huge", "statistics"}, ->
        div class:{"huge","statistic"}, ->
          div class:{"label"}, "#{@this.month}月の使用金額"
          div class:"value", "￥ #{@this_total}"
        div class:{"small", "grey", "statistic"}, ->
          div class:{"label"}, "#{@last.month}月の使用金額"
          div class:{"value"}, "￥ #{@last_total}"
