
# Module dependencies.
$ = require 'jQuery'
Backbone = require 'backbone'
ChatCollection = require './chat-collection.coffee'
ChatListView = require './chat-list-view.coffee'

Backbone.$ = $

class ChatApp

  constructor: (socket) ->
    collection = new ChatCollection socket
    listView = new ChatListView(collection: collection, el: $('#chat'))

module.exports = ChatApp
