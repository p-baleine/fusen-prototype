
# Module dependencies.
express = require 'express'
app = express()
server = app.listen 3000
io = require('socket.io').listen server

# Middleware
app.use express.static("#{__dirname}/public")

# Settings
app.set 'views', 'lib/views'
app.set 'view engine', 'jade'

# routes
app.get '/', (req, res) ->
  res.render 'index'
