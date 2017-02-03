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
    url = "#{BACKLOG_URL}view/#{body.project.projectKey}-#{body.content.key_id}"
    if body.content.comment?.id?
        url += "#comment-#{body.content.comment.id}"
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
            if i.field == 'summary'
              changes += "・タイトル: [#{oldVal}] -> [#{newVal}]\n"

            if i.field == 'status'
              oStatusId = i.old_value - 1
              nStatusId = i.new_value - 1
              oStatus = STATUS[oStatusId]
              nStatus = STATUS[nStatusId]
              changes += "・ステータス: [#{oStatus}] -> [#{nStatus}]\n"

            if i.field == 'assigner'
              changes += "・担当者: [#{oldVal}] -> [#{newVal}]\n"

            if i.field == 'limitDate'
              changes += "・期限日: [#{oldVal}] -> [#{newVal}]\n"

            if i.field == 'description'
              # 長いので新しい説明のみを表示させる
              # 改行をスペースに変換
              nDescription = newVal.replace(/\n/g, ' ') 
              # 長かったらぶった切って「…」を付与
              if nDescription.length > STR_LENGTH_MAX
                nDescription = nDescription[0..STR_LENGTH_MAX] + "…"
              changes += "・説明: 変更あり\n"

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

      # ```で囲む更新内容を整形
      detailMessage = ""
      # 説明
      if description != ""
        detailMessage += "#{description}\n"

      # 変更内容
      if changes != ""
        detailMessage += "------------------\n"
        detailMessage += "【変更内容】\n"
        detailMessage += "#{changes}"

      # コメントがあれば追加
      if body.content.comment?.content? && body.content.comment.content != ""
        detailMessage += "------------------\n"
        detailMessage += "【コメント】\n"
        detailMessage += "#{body.content.comment.content}\n"

      # 詳細コメントを本文に追加
      if detailMessage != ""
        message += "```#{detailMessage}```\n"

      # URL
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