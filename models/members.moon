db = require "lapis.db"
import Model, enum from require "lapis.db.model"

class Members extends Model
  @relations: {
    {"accounts", has_many: "Accounts"}
  }

  @color: enum {
    blue: 1
    red: 2
  }

  has_token: ->
    Members\select "where deleted = false and token <> ?", ""

  send_notification: ->
    Members\select "where deleted = ? and token <> ? and send = ?", db.FALSE, "", db.TRUE

  @delete_by_id: (id) =>
    member = Members\find @params.delete
    if member
      member\update {
        deleted: db.TRUE
      }

  @accounts_by_month: () =>
    import Accounts from require "models"
    members = @\select!
    unless members
      return {}

    by_month = {}
    for member in *members
      accounts = member\get_accounts!
      by_month[member.member] = Accounts.sum_up_amounts_by_month accounts
    by_month
