# Module dependencies.
Backbone = require 'backbone'
Bacon = require 'baconjs'
BaconUI = require 'baconui'
ChatItemView = require './chat-item-view.coffee'

KEYCODE_ENTER = 13

class ChatListView extends Backbone.View

  initialize: ->
    @listenTo @collection, 'add', @renderOne
    @$('#new-chat-message').asEventStream('keyup')
      .filter((e) -> e.keyCode is KEYCODE_ENTER and $(e.target).val().length > 0)
      .map((e) -> content: $(e.target).val())
      .assign(@collection, 'create')

  renderOne: (model) =>
    @$('ul').append (new ChatItemView model: model).render().el

module.exports = ChatListView
