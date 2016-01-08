app = require "./#{process.argv[2]}/nodes"
emitter = require './emitter'
filewalker = require 'filewalker'
path = require 'path'

types = {}
filewalker 'types'
  .on 'file', (p, s) ->
    base = path.basename p, '.js'
    types[base] = require "./types/#{base}"
  .on 'done', ->
    init()
  .walk()

init = ->
  units = {}
  nodes = {}

  for id, node of app.nodes
    type = node.type

    if not types[type]
      console.log "#{type} is an undefined type"
      continue

    nodes[id] = node
    units[id] = types[type] id, node.constants

    if node.on?
      do (id, node) ->
        emitter.on node.on, units[id].run

  for id, node of nodes
    if !!node.start
      units[id].run()
