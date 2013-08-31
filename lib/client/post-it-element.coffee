
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
    dragmove = new Bacon.Bus
    dragend = new Bacon.Bus

    # こちらの移動
    el.dragmove = dragmove.push
    drgmoveProperty = dragmove
      .map((delta) -> x: delta.x, y: delta.y)
    @commandDest.plug dragmove.map(@dragmoveCommand)

    # 移動の終わり
    el.dragend = dragend.push
    dragend = dragend.map (delta) => x: delta.x, y: delta.y
    dragend.assign (delta) =>
      @data.trans.x += delta.x
      @data.trans.y += delta.y
      el.transform x: @data.trans.x, y: @data.trans.y
    @commandDest.plug dragend.map(@dragendCommand)

    # 内容の編集
    startEdit.onValue =>
      $editor
        .css(left: @data.trans.x + 5, top: @data.trans.y + 5)
        .appendTo '#white-board'
    textProperty.assign $el.find('text').get(0).instance, 'text'
    textProperty.assign (text) => @data.text = text
    finishEdit.onValue $editor, 'detach', null
    @commandDest.plug finishEdit.map(@editCommand)

    # 外からの移動
    moving = @commandSrc.moving
      .filter(@isMine)
      .map((args) => x: @data.trans.x + args.delta.x, y: @data.trans.y + args.delta.y)
    moving.assign(el, 'transform')

    # 外からの移動の終わり
    moved = @commandSrc.moved
      .filter(@, 'isMine')
      .map((args) => x: @data.trans.x + args.delta.x, y: @data.trans.y + args.delta.y)
    moved.assign(el, 'transform')
    moved.assign (trans) =>
      @data.trans.x = trans.x
      @data.trans.y = trans.y

    # 外からの編集
    edited = @commandSrc.edited
      .filter(@isMine)
      .map((data) -> data.text)
    edited.assign($el.find('text').get(0).instance, 'text') # TODO refactoring
    edited.assign($editor, 'val') # TODO refactoring

  # 自分に対するコマンドか判定する
  isMine: (data) =>
    data.id is @data.id

  # `dragmove`コマンドを返却する
  dragmoveCommand: (delta) =>
    name: 'dragmove'
    data:
      id: @data.id
      delta: delta

  # `dragend`コマンドを返却する
  dragendCommand: (delta) =>
    name: 'dragend'
    data:
      id: @data.id
      delta: delta

  # `edit`コマンドを返却する
  editCommand: =>
    name: 'edit'
    data:
      id: @data.id
      text: @data.text

# ポストイットSVG要素を作成して返却する
PostItElement.createElement = (draw, data) ->
  # TODO useで再利用
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
