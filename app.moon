lapis = require "lapis"

import Input from "views.input"

class extends lapis.Application
  layout: require "views.layout"
  [index: "/"]: =>
    @page_title = "トップ"
    render: true
  [list: "/list"]: =>
    @page_title = "入出金一覧"
    render: true
  [input: "/input"]: =>
    @page_title = "出金入力"
    render: true
