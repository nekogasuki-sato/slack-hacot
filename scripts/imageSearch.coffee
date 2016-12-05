# Description:
#   画像検索
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
TIQAV_URL = "http://api.tiqav.com/search.json"

shuffle = (array) ->
  # For clone
  arr = array.slice()
  i = arr.length
  while --i
    j = Math.floor(Math.random() * (i + 1))
    tmp = arr[i]
    arr[i] = arr[j]
    arr[j] = tmp
  arr

# Avoid to be cached same url image by Slack
get_timestamp = () ->
  (new Date()).toISOString().replace(/[^0-9]/g, '')

# ちくわぶで画像検索
searchImageFromTiqav = (msg, query = {}) ->
  msg.http(TIQAV_URL).query(query).get() (err, res, body) ->
    json = JSON.parse body
    if json.length > 0
      items = shuffle json
      msg.send "http://img.tiqav.com/#{items[0].id}.th.#{items[0].ext}?#{get_timestamp()}"


module.exports = (robot) ->

  robot.respond /resimg (.+)$/i, (msg) ->
    keyword = msg.match[1]
    searchImageFromTiqav msg, {q: keyword}
