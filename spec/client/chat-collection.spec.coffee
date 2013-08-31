
# Module dependencies.
expect = require 'expect.js'
Backbone = require 'backbone'
ChatCollection = require '../../lib/client/chat-collection.coffee'

describe 'chat-collection', ->

  it 'Backbone.Collectionのインスタンスであること', ->
    expect(new ChatCollection).to.be.a Backbone.Collection
