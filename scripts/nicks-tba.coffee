# Description:
#   looks up frc teams in thebluealliance. ex:
#   tba teaminfo frc<team_number> ex. tba teaminfo frc3341
#   qm: qualifier, ef: idk, qf: quarterfinal, sf: semifinal, f: final
#
# Commands:
#   hubot tba teaminfo frc<teamnumber> - Looks up the specified event team and returns info on it
#   hubot tba matchinfo <matchnumber> - Looks up the specified match and returns info on it - only for sd qualifiers
#   hubot tba matchinfo <qm | ef | qf | sf | f> <number> match <number> Looks up the match info for specified qm/ef/qf/sf/f and match number
#
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md


module.exports = (robot) ->

  robot.respond /tba teaminfo (.*)/, (res) ->
    team = res.match[1]
    robot.http("https://www.thebluealliance.com/api/v2/team/" + team)
    .header('X-TBA-App-Id', 'frc3341:bluebot:v1')
    .get() (err, res2, body) ->
      try
        data = JSON.parse body
      catch error
        res.send "Ran into an error parsing JSON :("
        return

      message = "*Team Name:* #{data.name} \n"
      message += "*Nickname:* " + data.nickname + "\n"
      message += "*Location:* " + data.locality + ", " + data.region + ", " + data.country_name + "\n"
      message += "*Motto:* " + data.motto + "\n"
      message += "*Website:* " + data.website + "\n"
      res.send message

  robot.respond /tba matchinfo (.*)/, (res) ->
    args = res.match[1].split " "
    today = new Date
    year = today.getFullYear()
    if(args.length==1)
      key = year+"casd_qm"+args[0]
    if(args.length==4)
      key = year+"casd_"+args[0]+args[1]+"m"+args[3]
    res.send "checking tba on " + key
    robot.http("https://www.thebluealliance.com/api/v2/match/" + key)
    .header('X-TBA-App-Id', 'frc3341:bluebot:v1')
    .get() (err, res2, body) ->
      try
        data = JSON.parse body
      catch error
        res.send "Ran into an error parsing JSON :("
        return
      message = "*Match: " + data.match_number + "*\n"
      message += "*Blue:*\n"
      message += "*Score:* #{data.alliances.blue.score}\n"
      message += "*Teams:* #{data.alliances.blue.teams}\n"
      message += "*Red:*\n"
      message += "*Score:* #{data.alliances.red.score}\n"
      message += "*Teams:* #{data.alliances.red.teams}\n"
      res.send message

  robot.hear /hello/, (res) ->
    res.send "*hello*"
