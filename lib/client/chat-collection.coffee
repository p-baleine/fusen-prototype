
# Module dependencies.
Backbone = require 'backbone'
Bacon = require 'baconjs'

class ChatModel extends Backbone.Model

  sync: (method, model, options) ->
    if method is 'create'
      @collection.messages.push model.toJSON()
    else
      super method, model, options

class ChatCollection extends Backbone.Collection

  model: ChatModel

  initialize: (socket) ->
    @messages = new Bacon.Bus()
    @messages.onValue (message) -> socket.emit 'message', message
    newMessage = Bacon.fromEventTarget socket, 'message'
    newMessage.onValue (message) => @add message

module.exports = ChatCollection