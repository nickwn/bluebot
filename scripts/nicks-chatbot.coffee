# Description:
#   turns a chatbot on or off
# Commands:
#   hubot chatbot (on | off)

cleverbot = require('cleverbot-node')

module.exports = (robot) ->
  c = new cleverbot()

  c_bot_on = false

  robot.respond /(.*)/i, (msg) ->
    data = msg.match[1].trim()
    if c_bot_on && data != "chatbot off"
      cleverbot.prepare(( -> c.write(data, (c) => msg.send(c.message))))

  robot.respond /chatbot on/, (res) ->
    c_bot_on = true

  robot.respond /chatbot off/, (res) ->
    c_bot_on = false
