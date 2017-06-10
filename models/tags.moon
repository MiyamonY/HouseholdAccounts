import Model, enum from require "lapis.db.model"

class Tags extends Model
  @colors: enum {
    blue: 1
    red: 2
  }
