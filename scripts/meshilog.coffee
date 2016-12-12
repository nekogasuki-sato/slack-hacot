# Description:
#   食べたお店を覚えておくよ
#   (google spleadsheetに登録していくよ)
#
request = require 'request'
GAS_URL = "https://script.google.com/macros/s/AKfycbyAOo25j6VfbZIzc0H5c0402r8Uy6cOy4FnBe8KYXPAQXwkxQU/exec"

addMeshiLog = (msg, place, shop, food, username) ->
  msg.http(GAS_URL).query({
    func: "pushlog",
    place: place,
    shop: shop,
    food: food,
    username: username}).get() (err, res, body) ->
    throw err if err  # 接続エラーなどが発生した場合
    if res.statusCode is 200  # ステータスコードが「OK」の場合
      msg.reply "いいな〜！！また行こうね！"
    else
      msg.send "response error: #{res.statusCode}"  

getWhatAte = (msg, whenWord) ->
  request
    url: GAS_URL
    qs:
      func: "getlog"
      when: whenWord
  , (err, res, body) ->
    throw err if err  # 接続エラーなどが発生した場合
    if res.statusCode is 200  # ステータスコードが「OK」の場合
      result = JSON.parse(body)
      repMsg = ""
      if result.length > 0
        end = result.length - 1 + '' # あとでkeyと比較するため文字列に変換する
        for key,row of result
          repMsg += "#{row.week}曜日に#{row.place}の#{row.shop}で#{row.food}を"
          if key == end
            repMsg += "食べたよ！"
          else
            repMsg += "食べて、\r\n"
      else
        repMsg += "#{whenWord}のは覚えてないな〜なにか食べに行ったっけ？"
      msg.reply repMsg
    else
      msg.send "response error: #{res.statusCode}"  

module.exports = (robot) ->

  # 食べたものを記録する
  robot.respond /(.+)の(.+)で(.+)を[食|た]べ[(?:まし)?た]/, (msg) ->
    place = msg.match[1]
    shop  = msg.match[2]
    food  = msg.match[3]
    username = msg.message.user.name
    addMeshiLog msg, place, shop, food, username

  # 食べたものを思い出す
  robot.respond /(最近|昨日|おととい|一昨日|先週)(?:何|なに)(?:食|た)べたっけ？$/, (msg) ->
    whenWord = msg.match[1]
    getWhatAte msg, whenWord

  # 思い出せるのはいつのだっけ
  robot.respond /(?:いつ|何時)のめしログが(思|おも)い(出|だ)せる(.+)?？$/, (msg) ->
    msg.reply "「最近」「昨日」「おととい（一昨日）」「先週」のなら思い出せるよ〜！"
