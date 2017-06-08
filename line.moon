http = require "lapis.nginx.http"

class Line
  new: (@message) =>

  notify_to: (members) =>
    if members
      for member in *members
        token = member.token
        @@.send token, @message

  @send: (token, message) ->
    body, status_code, headers = http.simple
      url: "https://notify-api.line.me/api/notify"
      method: "POST"
      headers: {
        "Authorization":"Bearer #{token}"
      }
      body: {
        message: message\to_notify!
      }
    status_code

{:Line}
