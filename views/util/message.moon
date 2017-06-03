class Message
  new: (type, header, messages) =>
    @type = type
    @header = header
    @messages = messages

class MessageWidget
  create_message: (message) =>
    div class:{"ui", message.type, "message"}, ->
      i class:{"close", "icon"}
      div class:"header", message.header
      ul class:"list", ->
        for mes in *message.messages
          li mes

{:Message, :MessageWidget}
