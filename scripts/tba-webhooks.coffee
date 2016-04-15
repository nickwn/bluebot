# Description:
#   "Receive incoming webhook from TBA and broadcast them to the configured channel"
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_TBA_CHANNEL="#test"
#
# Commands:
#   None
#
# URLs:
#   POST /hubot/tba
#
#   Configure webhook to use this URL. Verification can be done over this too, it will output to the configured channel
#
# Author:
#   nh_99
room = process.env.HUBOT_TBA_CHANNEL
token = process.env.HUBOT_SLACK_TOKEN

module.exports = (robot) ->
  robot.router.post "/hubot/tba", (req, res) ->
    body = req.body
    envelope = robot.brain.userForId 'broadcast'
    envelope.user = {}
    envelope.user.room = envelope.room = room if room
    envelope.user.type = body.type or 'groupchat'
    robot.logger.info body.message_type
    switch body.message_type
      when 'upcoming_match'
        hasTeam = false
        hasTeam or= "frc3341" == team for team in body.message_data.team_keys
        if hasTeam
          message = '*Upcoming match:* '
          message += body.message_data.event_name + '\n'
          message += '*Time:* ' + twd(body.message_data.scheduled_time) + '\n'
          message += '*Teams:*\n'
          message += teams(body.message_data.team_keys)
      when 'match_score'
        hasTeam = false
        hasTeam or= "frc3341" == team for team in body.message_data.team_keys
        if hasTeam
          message = '*Match Score:* '
          message += body.message_data.event_name + '\n'
          message += '*Match Number:* ' + body.message_data.match.match_number + '\n'
          message += '*Time:* ' + twd(body.message_data.match.time) + '\n'
          message += '*Videos:* ' + video + '\n' for video in body.message_data.match.videos if (body.message_data.match.videos) > 0
          message += '*Blue Alliance:*\n' + '_Score:_ ' + body.message_data.match.alliances.blue.score + '\n'
          message += teams(body.message_data.match.alliances.blue.teams)
          message += '*Red Alliance:*\n'
          message += '_Score:_ ' + body.message_data.match.alliances.red.score + '\n'
          message += teams(body.message_data.match.alliances.red.teams)
      when 'alliance_selection'
        message = '*Alliance Selection:* ' + body.message_data.event.name + '\n'
        message += pick for pick in alliance.picks + ' *-' + i + '*\n' for alliance, i in body.message_data.event.alliances
      when 'verification'
        message = '*Webhook Verification*\n'
        message += '_Paste this in under the webhook verification page to verify your webhook. This MUST happen before you can get other webhooks._\n'
        message += body.message_data.verification_key
      when 'ping'
        robot.logger.info 'Ping received'

    # Remove the special slack formatting if you aren't using Slack
    if token == null
      message = stripslack(message)

    if message
      robot.logger.info message
      robot.send message
    res.writeHead 200, {'Content-Type': 'text/plain'}
    res.end 'Thanks'

twd = (time) ->
  date = new Date(time * 1000)
  return date.toUTCString()

teams = (teams) ->
  teambreak = ''
  teambreak += team + ' - http://thebluealliance.com/team/' +  team.replace('frc', '') + '\n' for team in teams
  return teambreak

stripslack = (toStrip) ->
  toStrip = toStrip.replace(new RegExp('\\*', 'g'), '')
  toStrip = toStrip.replace(new RegExp('\\_', 'g'), '')
  return toStrip
