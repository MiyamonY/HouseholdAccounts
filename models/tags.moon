import Model, enum from require "lapis.db.model"

class Tags extends Model
  @colors: enum {
    white: 1
    red: 2
    orange: 3
    yellow: 4
    olive: 5
    green: 6
    teal: 7
    blue: 8
    pink: 9
    grey: 10
    balck: 11
  }

  to_color: =>
    @@colors[@.color]
