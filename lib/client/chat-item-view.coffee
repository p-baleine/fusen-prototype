
# Module dependencies.
Backbone = require 'backbone'

class ChatItemView extends Backbone.View

  tagName: 'li'

  render: ->
    console.log @model.toJSON()
    @$el.html @template(@model.toJSON())
    @

  template: require './chat-item-view.html'

module.exports = ChatItemView
