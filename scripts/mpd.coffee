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
#  !play - start playlist
#  !shuffle - Shuffle the playlist
#  !clear - Clear the playlist
#  !seed - Seed the playlist with the entire library (useful when !cleared)
#  !skip - Skip the current song (planned voting later)
#
# Author:
#   lazypower

module.exports = (robot) ->
  # Scrape Controls
  robot.hear /https:\/\/(.*).youtube.com(.*)/i, (msg) ->
    # Filter by room
    if (msg.message.room == process.env.DJ_ROOM)
      videoid = msg.message.text.split("v=")[1]
      processVideo msg, videoid

  # Player Controls
  robot.hear /^!skip/i, (msg) ->
    playCtl(msg, 'Skipping', 'skip')

  robot.hear /^!play/i, (msg) ->
    playCtl(msg, 'Playing', 'play')

  robot.hear /^!shuffle/i, (msg) ->
    playCtl(msg, 'Shuffling playlist', '/playlist/shuffle')

  robot.hear /^!seed/i, (msg) ->
    playCtl(msg, 'Seeding playlist', '/playlist/seed')

  robot.hear /^!clear/i, (msg) ->
    playCtl(msg, 'Clearing playlist', '/playlist/clear')




playCtl = (msg, reply, ctl) ->
  if not process.env.DJ_API_URL
    msg.send "Error: Theres no DJ API specified. Herp Derp set DJ_API_URL"
    return
  url = "#{ process.env.DJ_API_URL }/player/#{ encodeURIComponent(ctl) }"
  msg.http(url).get() (err, res, body) ->
    msg.send "#{reply}"

processVideo = (msg, videoid) ->
  if not process.env.DJ_API_URL
    msg.send "Error: Theres no DJ API specified. Herp Derp set DJ_API_URL"
    return
  url = "#{ process.env.DJ_API_URL }/fetch/youtube/#{ encodeURIComponent(videoid) }"
  msg.http(url).get() (err, res, body) ->
    resp = JSON.parse(body)
    msg.send "Fetching: #{ msg.message.text }"
