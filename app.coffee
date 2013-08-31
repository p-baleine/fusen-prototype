
# Module dependencies.
express = require 'express'
app = express()
server = app.listen 3000
io = require('socket.io').listen server
debug = require('debug')('http')
Bacon = require 'baconjs'
room = require './room'

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
  edit = Bacon.fromEventTarget socket, 'edit'
  dragmove = Bacon.fromEventTarget socket, 'dragmove'

  join.onValue (cb) ->
    cb room
    debug 'join', arguments
    socket.broadcast.emit 'joined', 'hoge'

  edit.onValue ->
    debug 'edit', arguments
    socket.broadcast.emit 'edit'

  dragmove.onValue (data) ->
    debug 'dragmove', data
    socket.broadcast.emit 'moving', data
    