# Description:
#   ゲームのお知らせを通知するよ！
cronJob = require('cron').CronJob
CHANNEL = 'bot_test'
STONE = [
  '火',
  '風',
  '土',
  '水'
]
HAMMER = {
  "key0": {
    "item": "防具",
    "element": "土",
    "icon" : "ele_soil"
  },
  "key2": {
    "item": "メダル",
    "element": "火",
    "icon" : "ele_fire"
  },
  "key4": {
    "item": "武器",
    "element": "風",
    "icon" : "ele_wind"
  }
};

module.exports = (robot) ->
  # 指定チャンネルにメッセージを送る
  send = (msg) ->
    robot.send {room: CHANNEL}, msg

  # 素材ダンジョンの開始を通知
  notificationMaterialsByBdfe = (msg) ->
    d = new Date
    hour = d.getHours()
    hammerId = 0
    if hour != 0
      hammerId = hour % 6

    keyName = 'key' + hammerId
    hd = HAMMER[keyName]

    message = "[BDFE] :hammer:#{hd['item']}素材START！#{hd['element']}装備で行くべし！:#{hd['icon']}:"
    # msg.send message
    send message

  # notificationStoneByBdfe = ->


  robot.respond /test mat$/i, (msg) ->
    notificationMaterialsByBdfe msg

  # robot.respond /test stone$/i, (msg) ->
  #   notificationStoneByBdfe msg

  # Seconds    : 0-59
  # Minutes    : 0-59
  # Hours      : 0-23
  # DayOfMonth : 1-31
  # Months     : 0-11
  # DayOfWeek  : 0-6
  # Every      : */10
  # 2時間ごとに素材ダンジョンのスタート通知
  new cronJob('00 00 0,2,4,6,8,10,12,14,16,18,20,22 * * *', () ->
    notificationMaterialsByBdfe()
  ).start()

  # 今日の石通知
  # new cronJob('00 30 7 * * *', () ->
  #   notificationStoneByBdfe()
  # ).start()
