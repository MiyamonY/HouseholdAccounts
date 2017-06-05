import Model,enum from require "lapis.db.model"

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

  sum_up_amounts: (accounts) ->
    sum_up = 0
    for account in *accounts
      sum_up += account.amount
    sum_up
