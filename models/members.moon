db = require "lapis.db"
import Model, enum from require "lapis.db.model"

class Members extends Model
  @color: enum {
    blue: 1
    red: 2
  }

  has_token: ->
    Members\select "where deleted = false and token <> ?", ""

  send_notification: ->
    Members\select "where deleted = ? and token <> ? and send = ?", db.FALSE, "", db.TRUE
