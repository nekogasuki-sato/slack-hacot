# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

cronJob = require('cron').CronJob

module.exports = (robot) ->
	# Seconds　0-59
	# Minutes:0-59
	# Hours:0-23
	# DayOfMonth:1-31
	# Months:0-11
	# DayOfWeek:0-6


  # 特定のチャンネルへ送信するメソッド(定期実行時に呼ばれる)　
  send = (channel, msg) ->
    robot.send {room: channel}, msg

  # Crontabの設定方法と基本一緒 *(sec) *(min) *(hour) *(day) *(month) *(day of the week)
  # #your_channelと言う部屋に、平日の18:30時に実行
  new cronJob('*/15 * * * * 1-5', () ->
    # ↑のほうで宣言しているsendメソッドを実行する
    send '#general', "@all スケジュールは更新した？"
  ).start()


  # cronjob = new cronJob('*/15 * * * * 1-5', () =>
  #   envelope = room: "#general"
  #   robot.send envelope, "スケジュールは更新した？ @all"
  #   # robot.send "課題管理表は書きましたか？ @all"
  # )
  # cronjob.start()

  # module.exports = (robot) ->
  # cronTest = new cronJob('0 57 16 * * 1', () =>
  #   envelope = room: "#roomname"
  #   robot.send envelope, "ここにメッセージを突っ込みます。"
  # )
  # cronTest.start()


  #   new CronJob '0 * * * * *', () =>
  #   # これだとSlack#generalにメッセージが流れない
  #   # robot.messageRoom "#general", "テスト"

  #   # これならおっけー☆
  #   robot.messageRoom "general", "テスト"
  # , null, true, "Asia/Tokyo"

