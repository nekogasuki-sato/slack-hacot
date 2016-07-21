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

  new cronJob('00 30 18 * * 1-5', () ->
    # ↑のほうで宣言しているsendメソッドを実行する
    send 'general', "スケジュールは更新した？ @everyone"
  ).start()
