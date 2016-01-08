emitter = require '../emitter'

module.exports = (id, constants) ->
  run: (input) ->
    fs = require 'fs'
    fs.readFile input.file, constants?.type or 'utf-8', (err, data) ->
      emitter.emit id,
        file: file
        data: data
