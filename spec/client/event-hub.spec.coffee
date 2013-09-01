
# Module dependencies.
expect = require 'expect.js'
Bacon = require 'baconjs'
EventEmitter = require('events').EventEmitter
eventHub = require '../../lib/client/event-hub.coffee'

describe 'event-hub', ->

  before ->
    @emitter = new EventEmitter
    @hub = eventHub @emitter

  it 'socke.ioからの`joined`イベントストリームを返却すること', ->
    expect(@hub).to.have.property 'joined'
    expect(@hub.joined).to.be.a Bacon.EventStream

  it 'socke.ioからの`added`イベントストリームを返却すること', ->
    expect(@hub).to.have.property 'added'
    expect(@hub.added).to.be.a Bacon.EventStream

  it 'socke.ioからの`edited`イベントストリームを返却すること', ->
    expect(@hub).to.have.property 'edited'
    expect(@hub.edited).to.be.a Bacon.EventStream

  it 'socke.ioからの`moving`イベントストリームを返却すること', ->
    expect(@hub).to.have.property 'moving'
    expect(@hub.moving).to.be.a Bacon.EventStream

  it 'socke.ioからの`moved`イベントストリームを返却すること', ->
    expect(@hub).to.have.property 'moved'
    expect(@hub.moved).to.be.a Bacon.EventStream

  it 'socket.io向けの`commands`Busを返却すること', ->
    expect(@hub).to.have.property 'commands'
    expect(@hub.commands).to.be.a Bacon.Bus