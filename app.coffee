
# Module dependencies.
express = require 'express'
app = express()
port = process.env.PORT || 3000
server = app.listen port
io = require('socket.io').listen server
debug = require('debug')('http')
Bacon = require 'baconjs'
room = require './room'
id = room.elements.length

# Middleware
app.use express.static("#{__dirname}/public")

# Settings
app.set 'views', 'lib/views'
app.set 'view engine', 'jade'

# routes
app.get '/', (req, res) ->
  res.render 'index'

io.sockets.on 'connection', (socket) ->

  join = Bacon.fromEventTarget socket, 'join'
  add = Bacon.fromEventTarget socket, 'add'
  edit = Bacon.fromEventTarget socket, 'edit'
  dragmove = Bacon.fromEventTarget socket, 'dragmove'
  dragend = Bacon.fromEventTarget socket, 'dragend'

  join.onValue (cb) ->
    cb room
    debug 'join', arguments
    socket.broadcast.emit 'joined', 'hoge'

  add.onValue (data) ->
    debug 'add', arguments
    data.id = ++id + ''
    io.sockets.emit 'added', data

  edit.onValue (data) ->
    debug 'edit', arguments
    socket.broadcast.emit 'edited', data

  dragmove.onValue (data) ->
    debug 'dragmove', data
    socket.broadcast.emit 'moving', data

  dragend.onValue (data) ->
    debug 'dragend', data
    socket.broadcast.emit 'moved', data  

  message = Bacon.fromEventTarget socket, 'message'

  message.onValue (data) ->
    debug 'message', data
    socket.broadcast.emit 'message', data
  