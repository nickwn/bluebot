# Description
#   Logs all conversations
#
# Commands
#   hubot search logs <query>
#
# Notes:
#   Logs can be found at bot's logs/ directory
#
# Author:
#   spajus

module.exports = (robot) ->
  fs = require 'fs'
  fs.exists './logs/', (exists) ->
    if exists
      startLogging()
    else
      fs.mkdir './logs/', (error) ->
        unless error
          startLogging()
        else
          console.log "Could not create logs directory: #{error}"
  startLogging = ->
    console.log "Started logging"
    robot.hear /(.*)/, (msg) ->
      fs.appendFile logFileName(msg), formatMessage(msg), (error) ->
        console.log "Could not log message: #{error}" if error
  logFileName = (msg) ->
    safe_room_name = "#{msg.message.room}".replace /[^a-z0-9]/ig, ''
    "./logs/#{safe_room_name}.log"
  formatMessage = (msg) ->
    "[#{new Date()}] #{msg.message.user.name}: #{msg.message.text}\n"

  robot.respond /search logs (.*)/, (res) ->
    grepWithFork res, ".\\logs\\*", res.match[1], (err) ->
      if err
        res.send "There was an error in the search:\n ```#{err}```"

  child_process = require 'child_process'
  grepWithFork = (res, filename, regexp, done) ->
    cmd = 'findstr "' + regexp.toString() + '" ' + filename
    child_process.exec cmd, {maxBuffer: 2000000}, (err, stdout, stderr) ->
        res.send stdout.substring 0, 1000
        done(err)
