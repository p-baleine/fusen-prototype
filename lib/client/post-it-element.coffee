
# Module dependencies.
$ = require 'jQuery'
Bacon = require 'baconjs'
BaconUI = require 'baconui'
SVG = require 'SVG'
SVGDraggable = require 'SVGDraggable'
SVGFilter = require 'SVGFilter'

class PostItElement

  constructor: (@data, @commandDest, @commandSrc, draw) ->
    el = PostItElement.createElement draw, @data
    $el = $(el.node)
    $editor = $('<textarea/>', 'class': 'editor')

    startEdit = $el.asEventStream 'dblclick'
    finishEdit = $editor.asEventStream 'blur' # focusout
    textProperty = BaconUI.textFieldValue($editor, @data.text).map '.trim'
    dragmove = new Bacon.Bus()

    # こちらの移動
    el.dragmove = dragmove.push
    dragmove
      .map((delta) -> { x: delta.x, y: delta.y })
      .assign(el, 'transform')
    @commandDest.plug dragmove.map(@dragmoveCommand)

    # 内容の編集
    startEdit.onValue ->
      $editor
        .css(left: data.trans.x + 5, top: data.trans.y + 5)
        .appendTo '#white-board'
    textProperty.assign $el.find('text').get(0).instance, 'text'
    textProperty.assign (text) => @data.text = text
    finishEdit.onValue $editor, 'detach', null
    @commandDest.plug finishEdit.map(@editCommand)

    # 外からの移動
    @commandSrc.moving
      .filter((args) => args.id is @data.id)
      .map((args) -> x: args.delta.x, y: args.delta.y)
      .assign(el, 'transform')

  # `dragmove`コマンドを返却する
  dragmoveCommand: (delta) =>
    name: 'dragmove'
    data:
      id: @data.id
      delta: delta

  # `edit`コマンドを返却する
  editCommand: =>
    name: 'edit'
    data:
      id: @data.id
      text: 'hoge'

# ポストイットSVG要素を作成して返却する
PostItElement.createElement = (draw, data) ->
  g = draw.group()
  rect = g.rect(100, 100).attr(fill: data.fill)

  g.attr 'class', 'note'
  g.transform data.trans
  g.text(data.text).attr 'class', 'text'
  g.draggable()
  rect.filter (add) ->
    blur = add.offset(2, 2).in(add.sourceAlpha).gaussianBlur('1')
    add.blend add.source, blur

  g

module.exports = PostItElement
