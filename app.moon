lapis = require "lapis"
db = require "lapis.db"
util = require "lapis.util"
console = require "lapis.console"

import respond_to from require "lapis.application"
import Accounts, Kinds, Members, Tags from require "models"
import Message from require "views.util.message"

class extends lapis.Application
  layout: require "views.layout"
  @include "controllers.tag"
  @include "controllers.account"
  @include "controllers.member"

  [index: "/"]: =>
    @page_title = "トップ"
    @this = os.date("*t")
    @last = {k, v for k,v in pairs @this}
    print "#{util.to_json(@last)}"
    @last.month -= 1
    if @last.month == 0
      @last.month = 12
      @last.year -= 1
    where = "where EXTRACT(YEAR FROM date) = ? and EXTRACT(MONTH FROM date) = ?"
    accounts = Accounts\select where, @this.year, @this.month
    @this_total = 0
    for account in *accounts
      @this_total += account.amount
    accounts = Accounts\select where, @last.year, @last.month
    @last_total = 0
    for account in *accounts
      @last_total += account.amount
    render: true

  "/console": console.make!
