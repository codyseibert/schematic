app = require "./#{process.argv[2]}/nodes"
emitter = require './emitter'
filewalker = require 'filewalker'
path = require 'path'
Process = require './process'
log4js = require 'log4js'

logger = log4js.getLogger()

# load the types by walking the file system.  Each type is a function
types = {}
filewalker 'types'
  .on 'file', (p, s) ->
    base = path.basename p, '.js'
    logger.trace "Found process type: #{p}"
    types[base] = require "./types/#{base}"
  .on 'done', ->
    init()
  .walk()

# loads the nodes from the nodes.coffee object file
loggers = {}
init = ->
  processes = {}
  nodes = {}

  for id, node of app.nodes
    logger.trace "Looping through node #{id} with type #{node.type}"
    logger.trace "  start: #{!!node.start}"
    logger.trace "  config: #{JSON.stringify node.config}"
    type = node.type
    loggers[id] ?= log4js.getLogger id

    if not types[type]
      logger.error "#{type} is an undefined type"
      continue

    nodes[id] = node
    processes[id] = new Process id, nodes[id].config, loggers[id], types[type]

    do (id) ->
      if node.on?
        logger.trace "  #{node.on} -> #{id}"
        emitter.on nodes[id].on, (data) ->
          logger.trace "#{nodes[id].on} fired, calling #{id}"
          processes[id].run data

  for id, node of nodes
    if !!node.start
      logger.trace "starting #{id}"
      processes[id].run []
