# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md
headers = {'X-ChatWorkToken': process.env.HUBOT_CHATWORK_APITOKEN};
CHATWORK_BASE_URI = "https://api.chatwork.com/v1"
CHATWORK_ROOM_URL = "https://www.chatwork.com/#!rid"

# 一覧を表示
getList = (msg, type) ->
  request = require 'request'
  groupList = []
  request
    url: "#{CHATWORK_BASE_URI}/rooms"
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

# メッセージを送る
sendMessage = (msg, to, body) ->
  request = require 'request'
  request.post
    url: "#{CHATWORK_BASE_URI}/rooms/#{to}/messages"
    headers: headers
    form:
      body: "#{body}"
  , (err, response, body) ->
    throw err if err  # 接続エラーなどが発生した場合
    if response.statusCode is 200  # ステータスコードが「OK」の場合
   	  parsed = JSON.parse(body)
   	  msgId = parsed["message_id"]
      msg.send "send messege. <#{CHATWORK_ROOM_URL}#{to}-#{msgId}>"
    else
      msg.send "response error: #{response.statusCode}"  

# 自身の情報を表示
getMe = (msg) ->
  request = require 'request'
  groupList = []
  request
    url: "#{CHATWORK_BASE_URI}/me"
    headers: headers
  , (err, response, body) ->
    throw err if err  # 接続エラーなどが発生した場合
    if response.statusCode is 200  # ステータスコードが「OK」の場合
      parsed = JSON.parse(body)
      console.log parsed
      # msg.send "#{parsed}"
    else
      msg.send "response error: #{response.statusCode}"  
  

module.exports = (robot) ->

  robot.hear /テスト/i, (msg) ->
  	console.log headers

  robot.respond /chatwork( help)?$/i, (msg) ->
    msg.send """chatwork *** でchatworkAPIを叩くよ！コマンドはこんなかんじ！↓
    ```chatwork help             ヘルプだよ！
    chatwork me               botの情報を表示するよ！
    chatwork rooms group      グループ一覧を表示するよ！
    chatwork rooms direct     メンバー一覧を表示するよ！
    chatwork send @{room_id} {messege}  宛先(@)にメッセージ({messege})を送信するよ！chatworkの記法が使えるよ！
    ```
    """

  # chatworkに存在するグループ/メンバー一覧を取得
  robot.respond /chatwork rooms (group|direct)$/i, (msg) ->
    getList msg, msg.match[1]

  # メッセージを送る
  robot.respond /chatwork send @([0-9]{8}) ([\s\S]+)$/i, (msg) ->
  	sendMessage msg, msg.match[1], msg.match[2]

  robot.respond /chatwork me$/i, (msg) ->
    getMe msg