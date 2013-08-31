
# Module dependencies.
expect = require 'expect.js'
Backbone = require 'backbone'
ChatItemView = require '../../lib/client/chat-item-view.coffee'

describe 'chat-item-view', ->

  it 'Backbone.Viewのインスタンスであること', ->
    expect(new ChatItemView).to.be.a Backbone.View