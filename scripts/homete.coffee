# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

respondFoods = require './data/foods.json'
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

  robot.respond /今日なにたべる？/i, (msg) ->
    msg.send msg.random respondFoods

  robot.respond /(?:hacot )?(.+)食べたい/i, (msg) ->
    addFoods = msg.match[1]
    msg.send "そうなの？じゃあ#{addFoods}食べに行く？？"
    # respondFoods[] = addFoods
    # for food, index in respondFoods
    #   console.log "food: #{food} [#{index}]"

