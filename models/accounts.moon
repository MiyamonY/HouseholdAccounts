import Model,enum,preload from require "lapis.db.model"
import Members, Kinds from require "models"
import to_json from require "lapis.util"

class Accounts extends Model
  @relations: {
    {"member", belongs_to: "Members"}
    {"kind", belongs_to: "Kinds"}
  }

  @types: enum{
    payment: 1
  }

  select_by_date: (year, month, day) =>
    not_nil = false
    where = "where "
    if year
      where = where .. "EXTRACT(YEAR FROM date) = #{year}"
      not_nil = true
    if month
      if not_nil
        where = where .. " and "
      where = where .. "EXTRACT(MONTH FROM date) = #{month}"
      not_nil = true
    if day
      if not_nil
        where = where .. " and "
      where = where .. "EXTRACT(DAY FROM date) = #{day}"
    Accounts\select where

  to_json_data:  =>
    -- preload
    Members\include_in {@}, "member_id"
    Kinds\include_in {@}, "kind_id"
    {id:@.id, amount: @.amount, date:@.date, member:@.member.member, kind:@.kind.kind,
      input_date:@.input_date, etc:@.etc}

  sum_up_amounts: (accounts) ->
    sum_up = 0
    for account in *accounts
      sum_up += account.amount
    sum_up
