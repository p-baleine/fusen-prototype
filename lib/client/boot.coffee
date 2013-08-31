
'use strict'

# Module dependencies.
$ = require 'jQuery'
Bacon = require 'baconjs'
SVG = require 'SVG'
PostItElement = require './post-it-element.coffee'

# キャンバス初期化
init = (room, commandDest, commandSrc, draw) ->
  room.elements.forEach (element) ->
    new PostItElement element, commandDest, commandSrc, draw

$(->
  draw = SVG 'white-board'
  socket = io.connect '/'
  commandDest = new Bacon.Bus() # こちらからのコマンドの出口

  # socketにバインド
  commandDest.onValue (command) -> socket.emit command.name, command.data

  # 外からのコマンドの入り口
  socketStream = Bacon.fromEventTarget.bind Bacon, socket
  joined = socketStream('joined').log() # あとで実装
  added = socketStream('added').log() # あとで実装
  commandSrc =
    moving: socketStream('moving')

  socket.emit 'join', (room) ->
    init room, commandDest, commandSrc, draw
)
