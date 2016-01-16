emitter = require './emitter'
filewalker = require 'filewalker'
path = require 'path'
Process = require './process'
log4js = require 'log4js'
express = require 'express'
multer = require 'multer'
fs = require 'fs'
logger = require 'morgan'
coffee = require 'coffee-script'

upload = multer dest: 'uploads'

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

init = ->
  app = express()
  app.use log4js.connectLogger logger, level: log4js.levels.TRACE

  app.get '/status', (req, res) ->
    res.status 200
    res.send 'success'

  app.post '/run', upload.single('file'), (req, res, next) ->
    logger.info req.file

    script = fs.readFileSync "#{req.file.path}", 'utf-8'
    fs.writeFileSync "#{req.file.path}.js", coffee.compile script, 'utf-8'
    fs.unlinkSync req.file.path

    processes = {}
    nodes = {}
    loggers = {}
    nodesObject = require "./#{req.file.path}"

    for id, node of nodesObject.nodes
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

    res.status 200
    res.send 'running script'


  app.listen 10000
