# Description:
#   None
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot reddit <subreddit> - A random top (today) post from the specified subreddit. Tries to find a picture if possible
#
# Author:
#   artfuldodger

redditcache = {}

module.exports = (robot) ->
  robot.respond /reddit( .+)*/i, (msg) ->
    reddit msg, msg.match[1]?.trim()

  robot.respond /rcache/i, (msg) ->
    msg.send JSON.stringify(redditcache)

reddit = (msg, subreddit) ->
  if subreddit
    subreddits = subreddit.split('+')
    if subreddits.length > 1
      randy = Math.floor(Math.random() * subreddits.length)
      subreddit = subreddits[randy]

  url = if subreddit? then "http://www.reddit.com/r/#{subreddit}/top.json" else "http://www.reddit.com/top.json"
  msg
    .http(url)
      .get() (err, res, body) ->

        # Sometimes when a subreddit doesn't exist, it wants to redirect you to the search page.
        # Oh, and it doesn't send back 302s as JSON
        if body?.match(/^302/)?[0] == '302'
          msg.send "That subreddit does not seem to exist."
          return

        posts = JSON.parse(body)

        # If the response has an error attribute, let's get out of here.
        if posts.error?
          msg.send "That doesn't seem to be a valid subreddit. [http response #{posts.error}]"
          return

        unless posts.data?.children? && posts.data.children.length > 0
          msg.send "While that subreddit exists, there does not seem to be anything there."
          return

        post = getPost(posts)

        # split img url to get extension
        postParts = post.url.split(".")

        # if extension is .gifv replace it with .gif
        if postParts[ postParts.length - 1 ] is "gifv"
          postParts[ postParts.length - 1 ] = "gif"
          post.url = postParts.join(".")

        #if we've already seen all the top posts
        if post is -1
          msg.send "All top posts for this subreddit already displayed!"
          return

        # tries_to_find_picture = 0

        # while post?.domain != "i.imgur.com" && tries_to_find_picture < 30
        #   post = getPost(posts)
        #   tries_to_find_picture++

        # Send pictures with the url on one line so Campfire displays it as an image
        if post.domain == 'i.imgur.com'
          msg.send "#{post.title} - http://www.reddit.com#{post.permalink}"
          msg.send post.url
        else
          msg.send "#{post.title} - #{post.url} - http://www.reddit.com#{post.permalink}"



# return a fresh post
getPost = (posts) ->
  postFound = false
  temp_post = {}
  random = 0

  # loop until we find a post to return
  until postFound

    # if we've seen all the posts or
    # there are no posts
    # break the loop and return -1
    if posts.data.children.length > 0

      # grab a random post from the array
      random = Math.floor(Math.random() * posts.data.children.length)
      temp_post = posts.data.children[random].data

      # check for repeat posts
      # if a repeat post remove that post from the array for the next
      # iteration of our loop
      if checkPost(temp_post.id, temp_post.subreddit)
        posts.data.children.splice(random, 1)
      else
        # if a fresh post -> log it and return it
        logPost(temp_post.id, temp_post.subreddit)
        postFound = true

    else
      return -1

  temp_post




checkPost = (id, subreddit) ->
  if redditcache[ subreddit ]
    i = 0
    while i < redditcache[subreddit].length
      return true if redditcache[subreddit][i] is id
      i++

    false
  else
    false



logPost = (id, subreddit) ->
  if redditcache[subreddit]
    redditcache[subreddit].push id
  else
    redditcache[subreddit] = []
    redditcache[subreddit].push id
