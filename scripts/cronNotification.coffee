# Description:
#   ゴミの日を通知するよ
cronJob = require('cron').CronJob
CHANNEL = "general"
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

module.exports = (robot) ->
  # 指定チャンネルにメッセージを送る
  send = (msg) ->
    robot.send {room: CHANNEL}, msg

  # メッセージ作成
  makeMessage = (week) ->
    returnMessage = "明日は#{GOMI[week]}を出す日だよー"
    returnMessage += COMMENT[week]

  # 曜日をチェック
  whatDayIsToday = ->
    d = new Date
    week = d.getDay()
    message = makeMessage(week)
    send message

  robot.respond /get week$/i, (msg) ->
    whatDayIsToday msg

  # Seconds    : 0-59
  # Minutes    : 0-59
  # Hours      : 0-23
  # DayOfMonth : 1-31
  # Months     : 0-11
  # DayOfWeek  : 0-6
  # Every      : */10
  # 水金土は次の日ゴミ出しがないので通知をしない
  new cronJob('00 00 21 * * 0,1,2,4', () ->
    whatDayIsToday()
  ).start()

  new cronJob('00 00 10 5,9 * *', () ->
    d = new Date
    day = d.getDate()
    toLimitDate = 10 - day
    message = "@hodaka 保険振込#{toLimitDate}日前だよーコンビニ行って払ってきてね！"
    send message
  ).start()
