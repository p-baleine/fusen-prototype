
# Module dependencies.
expect = require 'expect.js'
Backbone = require 'backbone'
EventEmitter = require('events').EventEmitter
ChatCollection = require '../../lib/client/chat-collection.coffee'

describe 'chat-collection', ->

  it 'Backbone.Collectionのインスタンスであること', ->
    expect(new ChatCollection(new EventEmitter)).to.be.a Backbone.Collection
