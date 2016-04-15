# Description:
#   searches a custom search with a query
# Commands:
#   hubot search <query> searches a custom search with a query

module.exports = (robot) ->

  robot.respond /search (.*)/, (res) ->
    query = res.match[1]
    if query.toString().search('logs') == -1
      cx = process.env.HUBOT_GOOGLE_CSE_ID
      key = process.env.HUBOT_GOOGLE_CSE_KEY
      res.http("https://www.googleapis.com/customsearch/v1?q=#{query}&cx=#{cx}&key=#{key}")
        .get() (err, res2, body) ->
          if err
            if res2.statusCode is 403
              res.send "*Daily image quota exceeded, using alternate source.*"
              deprecatedImage(msg, query, animated, faces, cb)
            else
              res.send "*Encountered an error :( #{err}*"
            return
          if res2.statusCode isnt 200
            res.send "Bad HTTP response :( #{res2.statusCode}"
            return
          data = JSON.parse(body)
          message = "*I found this: *\n"
          message += "*" + data.items[0].title + "*\n"
          message += data.items[0].snippet + "\n"
          message += data.items[0].link + "\n"
          res.send message
