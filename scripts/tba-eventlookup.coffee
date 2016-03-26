# Description:
#   Allows for the lookup of different events
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot eventlookup <eventcode> - Looks up the specified event code and returns info on the event. Event code reference: https://goo.gl/a8rb8M
#
# Author:
#   nh_99
token = process.env.HUBOT_SLACK_TOKEN

module.exports = (robot) ->

  robot.respond /eventlookup (.*)/i, (msg) ->
    eventToSearch = msg.match[1]
    robot.logger.info eventToSearch
    robot.http('http://www.thebluealliance.com/api/v2/event/' + eventToSearch)
      .header('X-TBA-App-Id', 'frc5506:hubot-tba-scripts:v0.1')
      .get() (err, res, body) ->
        data = JSON.parse body
        message = '*Results for ' + data.name + '*\n'
        message += '*Location:* ' + getLocation(data.venue_address) if data.venue_address
        message += '*Website:* ' + data.website + '\n' if data.website
        message += '*Start Date:* ' + data.start_date if data.start_date
        if token = null
          message = stripslack(message)
        msg.send(message)

  stripslack = (toStrip) ->
    toStrip = toStrip.replace(new RegExp('\\*', 'g'), '')
    toStrip = toStrip.replace(new RegExp('\\_', 'g'), '')
    return toStrip

  getLocation = (location) ->
    mapType = "roadmap"
    location = encodeURIComponent(location)
    mapUrl   = "http://maps.google.com/maps/api/staticmap?markers=" +
                location +
                "&size=400x400&maptype=" +
                mapType +
                "&sensor=false" +
                "&format=png" # So campfire knows it's an image
    url      = "http://maps.google.com/maps?q=" +
               location +
              "&hl=en&sll=37.0625,-95.677068&sspn=73.579623,100.371094&vpsrc=0&hnear=" +
              location +
              "&t=m&z=11"

    return mapUrl + '\n' + url + '\n'
