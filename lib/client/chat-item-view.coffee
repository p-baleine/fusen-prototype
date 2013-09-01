
# Module dependencies.
Backbone = require 'backbone'

class ChatItemView extends Backbone.View

  tagName: 'li'

  render: ->
    @$el.html @template(@model.toJSON())
    @

  template: require './chat-item-view.html'

module.exports = ChatItemView
