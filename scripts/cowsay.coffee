# Description:
#   ASCII art
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot cowsay me <text> - Show cow saying text
#
# Author:
#   nickwn
module.exports = (robot) ->
  robot.respond /cowsay( me)? (.+)/i, (msg) ->
    msg
      .http("http://api.textart.io/cowsay?text='#{msg.match[2]}'")
      .get() (err, res, body) ->
        obj = JSON.parse(body)
        if obj.contents?
          b = new Buffer(obj.contents.cowsay, 'base64')
          msg.send "```" + b.toString() + "```"
        else
          msg.send "```Error: quota exceeded:\n" + JSON.stringify(obj) + "```"
