# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
headers = {'X-ChatWorkToken':'c6be5ddeaef0bfb0b02901596848ffeb'};

getList = (msg, type) ->
  msg.send type
  request = require 'request'
  groupList = []
  request
    url: 'https://api.chatwork.com/v1/rooms'
    headers: headers
  , (err, response, body) ->
    throw err if err  # 接続エラーなどが発生した場合
    if response.statusCode is 200  # ステータスコードが「OK」の場合
      parsed = JSON.parse(body)
      for key,row of parsed
        if row["type"] is type
          # グループ名を配列に格納
          groupList.push(row["name"]+" @"+row["room_id"])
      if groupList.length > 0
        msg.send groupList.join("\r\n")
      else
        msg.send "There is no #{type}."
    else
      msg.send "response error: #{response.statusCode}"  


module.exports = (robot) ->

  # chatworkに存在するグループ/メンバー一覧を取得
  robot.respond /chatwork list (group|direct)/i, (msg) ->
    getList msg, msg.match[1]

  robot.respond /おーい/i, (msg) ->
    msg.send "なあに？"
