# Description:
#   Backlog to Slack
#
# Commands:
#   None
BACKLOG_URL = "https://haco.backlog.jp/"

module.exports = (robot) ->
  robot.router.post "/room/:room", (req, res) ->
    console.info req.body
    # room = req.params.room
    # body = req.body
    # console.log req.params
    # try
    #   switch body.type
    #     when 1
    #       label = '課題の追加'
    #     when 2, 3
    #       # 「更新」と「コメント」は実際は一緒に使うので、一緒に。
    #       label = '課題の更新'
    #     else
    #       # 課題関連以外はスルー
    #       return true

    #   # 投稿メッセージを整形
    #   url = "#{BACKLOG_URL}view/#{body.project.projectKey}-#{body.content.key_id}"
    #   if body.content.comment?.id?
    #       url += "#comment-#{body.content.comment.id}"

    #   message = ":backlog: *Backlog #{label}*\n"
    #   message += "[#{body.project.projectKey}-#{body.content.key_id}] - "
    #   # message += "#{body.content.summary} _by #{body.createdUser.name}_\n>>> "
    #   message += "#{body.content.summary} "
    #   # notificatonに通知したい人がいればその名前をメンションしてくれる
    #   if body.notifications.length > 0
    #     message += "to "
    #     for a in body.notifications
    #       console.log a.user.name
    #       message += "#{a.user.name} "

    #   message += "\n"

    #   if body.content.comment?.content?
    #       message += "```#{body.content.comment.content}```\n"
    #   message += "#{url}"

    #   # Slack に投稿
    #   if message?
    #       robot.messageRoom room, message
    #       res.end "OK"
    #   else
    #       robot.messageRoom room, "Backlog integration error."
    #       res.end "Error"
    # catch error
    #   robot.send
    #   res.end "Error"