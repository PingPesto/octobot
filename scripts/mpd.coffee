# Description:
#   Scrapes the channel for URLS and hands them off to the DJ API
#
# Dependencies:
#   None
#
# Configuration:
#   DJ_API_URL -- link to DJ API
#
# Commands:
#  paste any compliant URL from... youtube, soundcloud, mixcloud
#
# Author:
#   lazypower

module.exports = (robot) ->
  robot.hear /https:\/\/www.youtube.com(.*)/i, (msg) ->
    # Filter by room
    if (msg.message.room == process.env.DJ_ROOM)
        videoid = msg.message.text.split("v=")[1]
        processVideo msg, videoid

processVideo = (msg, videoid) ->
  if not process.env.DJ_API_URL
    msg.send "Error: Theres no DJ API specified. Herp Derp set DJ_API_URL"
  if not (process.env.DJ_API_URL)
    return
  url = "#{ process.env.DJ_API_URL }/fetch/youtube/#{ encodeURIComponent(videoid) }"
  msg.http(url).get() (err, res, body) ->
    resp = JSON.parse(body)
    msg.send "Fetching: #{ msg.message.text }"
