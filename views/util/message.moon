import enum from require "lapis.db.model"
import print_as_json from require "util"
import Accounts from require "models"

class Message
  @types: enum {
    add: 1
    correct: 2
    delete: 3
    validation_error:4
    db_error: 5
  }

  color: =>
    switch @type
      when @@.types.add
        "teal"
      when @@.types.correct
        "yellow"
      when @@.types.delete
        "red"
      when @@.types.validation_error
        "red"
      when @@.types.db_error
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

class MemberMessage extends Message
  new: (type, header, @member) =>
    messages = {"名前: #{@member.member}",
      "トークン: " .. if @member.token != "" then "入力済み" else "入力なし",
      "通知: " .. if @member.send then "する" else "しない"
    }
    super type, header, messages

class TagMessage extends Message
  new: (type, header, @tag) =>
    import print_as_json from require "util"
    print_as_json @tag.color
    print_as_json @tag\to_color!
    messages = {"名前: #{@tag.name}",
    "色: #{@tag\to_color!}"
    }
    super type, header, messages

class MessageWidget
  create_message: (messages) =>
    if messages
      for message in *messages
        div class:{"ui", message.color, "message"}, ->
          i class:{"close", "icon"}
          div class:"header", message.header
          ul class:"list", ->
            for mes in *message.messages
              li mes

{:AccountMessage, :Message, :MessageWidget, :MemberMessage, :TagMessage}
