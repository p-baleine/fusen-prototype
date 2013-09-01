
# Module dependencies.
_ = require 'underscore'
Bacon = require 'baconjs'

exports = module.exports = (socket) ->

  events = [
    'joined' # 他ユーザが参加した
    'added'  # 新しくポストイットが追加された
    'edited' # ポストイットが編集された
    'moving' # ポストイット移動中
    'moved'  # ポストイット移動した
  ]
  commands = new Bacon.Bus() # コマンド
  socketStream = _.bind Bacon.fromEventTarget, socket

  _.extend commands: commands, _.reduce(events, (memo, e) ->
    memo[e] = socketStream(e)
    memo
  , {})

