import Model,enum,preload from require "lapis.db.model"
import iter, parse_date, print_as_json from require "util"

class Accounts extends Model
  @relations: {
    {"member", belongs_to: "Members"}
    {"kind", belongs_to: "Kinds"}
  }

  @types: enum{
    payment: 1
  }

  @select_by_date: (year, month, day) =>
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
    @@\select where

  to_json_data:  =>
    import Members, Kinds from require "models"
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

  sum_up_amounts_by_month: (accounts) ->
    sum_up = {}
    sum_up_by_month = (account) ->
      date = parse_date account.date
      index = "#{date.year}年#{date.month}月"
      unless sum_up[index]
        sum_up[index] = 0
      sum_up[index] += account.amount
    iter accounts, sum_up_by_month
    sum_up
