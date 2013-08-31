
# Module dependencies.
expect = require 'expect.js'
sinon = require 'sinon'
Backbone = require 'backbone'
ChatCollection = require '../../lib/client/chat-collection.coffee'
ChatListView = require '../../lib/client/chat-list-view.coffee'
ChatItemView = require '../../lib/client/chat-item-view.coffee'

describe 'chat-list-view', ->

  beforeEach ->
    @testbed = """
      <div id=\"chat\">
        <ul id=\"chat-list\">
        </ul>
        <input id=\"new-chat-message\" type=\"text\" />
      </div>
    """
    @collection = new Backbone.Collection
    @collection.url = '/piyo'
    @view = new ChatListView collection: @collection, el: $(@testbed)

  it 'Backbone.Viewのインスタンスであること', ->
    expect(@view).to.be.a Backbone.View

  describe '#initialize()', ->

    beforeEach ->
      @renderSpy = sinon.spy ChatItemView::, 'render'

    afterEach ->
      ChatItemView::render.restore()

    it '`collection`の`add`イベントでItemViewを描画すること', ->
      @collection.trigger 'add', new Backbone.Model(content: 'hoe')
      expect(@renderSpy.called).to.be.ok()

  describe '新規作成', ->

    describe '#new-chat-messageでEnter keyが押された時', ->

      beforeEach ->
        @event = Backbone.$.Event 'keyup'
        @event.keyCode = 13
        @createSpy = sinon.spy @collection, 'create'

      afterEach ->
        @collection.create.restore()

      it '#new-chat-messageの内容で`collection`の`create`してること', ->
        @view.$('#new-chat-message').val('hoge').trigger @event
        expect(@createSpy.called).to.be.ok()
