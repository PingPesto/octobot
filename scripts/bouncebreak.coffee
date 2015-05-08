# Bounce Break script
# 
# bounce me - Send a random bouncebreak.com image

htmlparser = require "htmlparser"

module.exports = (robot) ->
  robot.respond /(bounce|bouncebreak)( me)?/i, (msg) ->
    bounceBreakCall msg, (image_url) ->
      msg.send image_url

bounceBreakRegexp = /img src="(http:\/\/i.imgur.com\/[^"]+)"/
bounceBreakCall = (msg, cb) ->
  msg.http("http://bouncebreak.tumblr.com/rss")
    .get() (err, res, body) ->
      handler = new htmlparser.RssHandler (error, dom) ->
        return if error || !dom
        item_length = dom.items.length
        item = dom.items[Math.floor(Math.random() * (item_length - 1))]
        match = item.description.match(bounceBreakRegexp)
        cb match[1] if match

      try
        parser = new htmlparser.Parser(handler)
        parser.parseComplete(body)

      catch ex
        msg.send "Erm, something went EXTREMELY wrong - #{ex}"