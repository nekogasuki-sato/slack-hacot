# Description:
#   ゴミの日を通知するよ
cronJob = require('cron').CronJob
CHANNEL = "bot_test"
GOMI = [
  'もえないゴミ・有害危険ゴミ・古紙類・繊維', # 月
  'もえるゴミ', # 火
  'びん・缶・ペットボトル・食品包装プラスチック', # 水
  '', # 木
  'もえるゴミ' # 金
]
COMMENT = [
  "\nダンボールは十字に縛って、不燃ごみは透明な袋にいれてね！", # 月
  "\nリビング、冷蔵庫の生ゴミ、ベランダ、洗面所、トイレ、仕事部屋のゴミ箱をチェックだ！", # 火
  "", # 水
  "", # 木
  "\nリビング、冷蔵庫の生ゴミ、ベランダ、洗面所、トイレ、仕事部屋のゴミ箱をチェックだ！" # 金
]

# 曜日をチェック
whatDayIsToday = (msg)->
  d = new Date
  week = d.getDay()
  message = makeMessage(week)
  send message

# メッセージ作成
makeMessage = (week) ->
  returnMessage = "明日は#{GOMI[week]}を出す日だよー"
  returnMessage += COMMENT[week]

# 指定チャンネルにメッセージを送る
send = (msg) ->
  robot.send {room: CHANNEL}, msg


module.exports = (robot) ->
  robot.respond /get week$/i, (msg) ->
    whatDayIsToday msg

# Seconds　0-59
  # Minutes:0-59
  # Hours:0-23
  # DayOfMonth:1-31
  # Months:0-11
  # DayOfWeek:0-6
  # new cronJob('00 10 7 * * *', () ->
  #   getWeather()
  # ).start()
