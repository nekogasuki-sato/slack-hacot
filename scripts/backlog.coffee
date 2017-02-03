# Description:
#   Backlog to Slack
#
# Commands:
#   None
BACKLOG_URL = "https://haco.backlog.jp/"
STATUS = ['未対応', '処理中', '処理済み', '完了']
STR_LENGTH_MAX = 100

module.exports = (robot) ->
  robot.router.post "/room/:room", (req, res) ->
    # console.info req.body
    room = req.params.room
    body = req.body
    try
      description = ""
      changes = ""
      switch body.type
        when 1
          label = '課題の追加'
          # 課題の追加のときのみ説明を追加
          if body.content.description != ""
            description = body.content.description
        when 2
          # 更新
          label = '課題の更新'
          console.info(body.content.changes)
          for i in body.content.changes
            console.info(i.field)
            oldVal = i.old_value
            newVal = i.new_value
            if i.field == 'status'
              oStatus = STATUS[i.old_value]
              nStatus = STATUS[i.new_value]
              changes += ">・ステータス: [#{oStatus}] -> [#{nStatus}]\n"
            if i.field == 'limitDate'
              changes += ">・期限日: [#{oldVal}] -> [#{newVal}]\n"
            if i.field == 'description'
              oldVal.replace(/\n/g, '\n')
              newVal.replace(/\n/g, '\n')
              console.info(oldVal)
              if oldVal.length > STR_LENGTH_MAX
                oldVal[0..STR_LENGTH_MAX] + "…"
              if newVal.length > STR_LENGTH_MAX
                newVal[0..STR_LENGTH_MAX] + "…"
              console.info(oldVal)
              changes += ">・説明: [#{oldVal}]\n-> [#{newVal}]\n"

        when 3
          # コメント
          label = '課題にコメント'
        else
          # 課題関連以外はスルー
          return true

      # 投稿メッセージを整形
      message = ":backlog: *Backlog #{label}*\n"
      message += "[#{body.project.projectKey}-#{body.content.key_id}] - "
      message += "#{body.content.summary} "

      # notificatonに通知したい人がいればその名前をメンション
      if body.notifications.length > 0
        message += "to "
        for a in body.notifications
          console.log a.user.name
          message += "#{a.user.name} "

      message += "\n"

      # 説明
      if description != ""
        message += "```#{body.content.description}```\n"

      # 変更内容
      if changes != ""
        message += "#{changes}"

      # コメントがあれば追加
      if body.content.comment?.content? && body.content.comment.content != ""
        message += "```#{body.content.comment.content}```\n"

      # URL
      url = "#{BACKLOG_URL}view/#{body.project.projectKey}-#{body.content.key_id}"
      if body.content.comment?.id?
          url += "#comment-#{body.content.comment.id}"
      message += "#{url}"

      # Slack に投稿
      if message?
        robot.messageRoom room, message
        res.end "OK"
      else
        robot.messageRoom room, "Backlog integration error."
        res.end "Error"
    catch error
      robot.send
      res.end "Error"