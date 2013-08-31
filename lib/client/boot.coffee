
'use strict'

# Module dependencies.
$ = require 'jQuery'
Bacon = require 'baconjs'
SVG = require 'SVG'
PostItElement = require './post-it-element.coffee'
ChatApp = require './chat-app.coffee'

# キャンバス初期化
init = (room, commandDest, commandSrc, draw) ->
  room.elements.forEach (element) ->
    new PostItElement element, commandDest, commandSrc, draw

# `add`コマンドを返却する
addCommand = () ->
  name: 'add'
  data:
    type: 'note'
    fill: '#f06'
    trans:
      x: 10
      y: 10
    text: $('#new-note-text').val()

$(->
  draw = SVG 'white-board'
  socket = io.connect '/'
  commandDest = new Bacon.Bus() # こちらからのコマンドの出口

  # socketにバインド
  commandDest.onValue (command) -> socket.emit command.name, command.data

  # 外からのコマンドの入り口
  socketStream = Bacon.fromEventTarget.bind Bacon, socket
  joined = socketStream('joined').log() # あとで実装
  added = socketStream('added')
  commandSrc =
    edited: socketStream('edited')
    moving: socketStream('moving')

  added.onValue (data) -> new PostItElement data, commandDest, commandSrc, draw

  # 新規作成
  commandDest.plug $('#paste').asEventStream('click')
    .map(addCommand)
    .doAction(-> $('#new-note-text').val(''))

  # 参加
  socket.emit 'join', (room) ->
    init room, commandDest, commandSrc, draw

  # チャット
  new ChatApp socket
)
