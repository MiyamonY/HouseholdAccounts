lapis = require "lapis"

import Members, Accounts from require "models"
import print_as_json, map from require "util"

class Statistics extends lapis.Application
  @path: "/statistics"
  @name: "statistics_"

  [statistics: "/"]: =>
    by_month = Members\accounts_by_month!
    @data = {}
    for name, data in pairs by_month
      for month, total in pairs data
        unless @data[month]
          @data[month] = {}
        @data[month][name] = total
    print_as_json @data
    @members = map Members\select!, (member) -> member.member
    render: "statistics.statistics"
