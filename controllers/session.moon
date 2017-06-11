import map, print_as_json from require "util"

class Session
  new: (@session) =>

  push_messages: (messages) =>
    for_session = (message) -> message\for_session!
    @session.messages = map messages, for_session
    print_as_json @session.messages

  pop_messages: =>
    messages = @session.messages
    @session.messages = nil
    messages

{:Session}
