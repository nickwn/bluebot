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
#   hubot ascii me <text> - Show text in ascii art
#
# Author:
#   nickwn
module.exports = (robot) ->
  robot.respond /ascii( me)? (.+)/i, (msg) ->
    msg
      .http("http://api.textart.io/figlet?text='#{msg.match[2]}'")
      .get() (err, res, body) ->
        obj = JSON.parse(body)
        if obj.contents?
          b = new Buffer(obj.contents.figlet, 'base64')
          msg.send "```" + b.toString() + "```"
        else
            msg.send "```Error: quota exceeded:\n" + JSON.stringify(obj) + "```"
