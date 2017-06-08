import enum from require "lapis.db.model"
import print_as_json from require "util"
import Accounts from require "models"

class Message
  @types: enum {
    add: 1
    correct: 2
    delete: 3
  }

  color: =>
    switch @type
      when @@.types.add
        "teal"
      when @@.types.correct
        "yellow"
      when @@.types.delete
        "red"
      else
        "brown"

  new: (@type, @header, @messages) =>

  for_session: => {type: @type, header:@header, messages:@messages, color:@\color!}


class AccountMessage extends Message
  new: (type, header, @account) =>
    messages = {"支払い日: #{@account.date}",
      "払った者: #{@account\get_member!.member}"
      "項目: #{@account\get_kind!.kind}",
      "金額: ￥ #{@account.amount}",
      "その他: #{@account.etc}"
      }
    super type, header, messages

  to_notify: =>
    this = os.date "*t"
    accounts = Accounts\select_by_date this.year, this.month
    total = Accounts.sum_up_amounts accounts
    table.concat {"",
      "#{@header}"
      "-----",
      "支払い日: #{@account.date}",
      "払った人: #{@account\get_member!.member}"
      "項目: #{@account\get_kind!.kind}",
      "金額: ￥ #{@account.amount}",
      "その他: #{@account.etc}",
      "-----"
      "今月の使用金額: ￥#{total}"
      }, "\n"

class MessageWidget
  create_message: (message) =>
    div class:{"ui", message.color, "message"}, ->
      i class:{"close", "icon"}
      div class:"header", message.header
      ul class:"list", ->
        for mes in *message.messages
          li mes

{:AccountMessage, :Message, :MessageWidget}
