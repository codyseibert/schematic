emitter = require '../emitter'

module.exports = (id, constants) ->
  run: ->
    fs = require 'fs'
    fs.watch constants.file, (event, filename) ->
      console.log 'emitting watcher'
      emitter.emit id, file: constants.file
