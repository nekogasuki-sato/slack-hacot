# Description:
#   食べたお店を覚えておくよ
#   (google spleadsheetに登録していくよ)
#
request = require 'request'
GAS_URL = "https://script.google.com/macros/s/AKfycbyAOo25j6VfbZIzc0H5c0402r8Uy6cOy4FnBe8KYXPAQXwkxQU/exec"

addMeshiLog = (msg, place, shop, food, username) ->
  msg.http(GAS_URL).query({place:place, shop:shop, food:food, username:username}).get() (err, res, body) ->
    throw err if err  # 接続エラーなどが発生した場合
    if res.statusCode is 200  # ステータスコードが「OK」の場合
      msg.reply "いいな〜！！また行こうね！"
    else
      msg.send "response error: #{response.statusCode}"  

module.exports = (robot) ->

  robot.respond /(.+)の(.+)で(.+)を[食|た]べ[(?:まし)?た]/, (msg) ->
    place = msg.match[1]
    shop  = msg.match[2]
    food  = msg.match[3]
    username = msg.message.user.name
    addMeshiLog msg, place, shop, food, username

