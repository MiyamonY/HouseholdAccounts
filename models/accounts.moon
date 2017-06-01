import Model,enum from require "lapis.db.model"

class Accounts extends Model
  @relations: {
    {"member", belongs_to: "Members"}
    {"kind", belongs_to: "Kinds"}
  }

  @types: enum{
    payment: 1
  }
