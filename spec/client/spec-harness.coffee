
Backbone = require 'backbone'
$ = require 'jQuery'

Backbone.$ = $
mocha.setup ignoreLeaks: true

require './chat-collection.spec.coffee'
require './chat-list-view.spec.coffee'
require './chat-item-view.spec.coffee'
require './event-hub.spec.coffee'
