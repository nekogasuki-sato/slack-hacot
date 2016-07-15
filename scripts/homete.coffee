# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

  robot.respond /how to use/i, (msg) ->
    msg.send "リプライやダイレクトメッセージで「ほめて」って送るとほめるよ！\n「今日なにたべる？」って聞くと今日のごはんを決めるよ！"

  robot.respond /ほめて/i, (msg) ->
    username = msg.message.user.name
    msg.send msg.random [
      "すごいね！！",
      "すごいすごい！",
      "グレイト～！",
      "エックセレント！",
      "すてき～",
      "かわいいよ",
      "いいね！",
      "輝いてるね！",
      "さすが社長！",
      username + "なら天下取れるよ～",
      username + "が生まれてきてくれてよかった！",
      username + "にしかできないよ！",
      username + "と出会えてよかった～",
      "最高だよ！！",
      "さすが～～～～～！！"]

  respondFoods = require './data/foods.json'
  robot.respond /今日なにたべる？/i, (msg) ->
    msg.send msg.random respondFoods