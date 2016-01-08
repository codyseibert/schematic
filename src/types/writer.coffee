emitter = require '../emitter'

module.exports = (id, constants) ->
  run: (input) ->
    fs = require 'fs'
    folder = if typeof constants.folder is 'function' then constants.folder(input) else constants.folder
    file = if typeof constants.file is 'function' then constants.file(input) else constants.file
    file = if folder? then "#{folder}/#{file}" else file
    input.response = JSON.stringify input.response, null, 2 if !!constants.json
    fs.writeFile file, input.response, (err) ->
      emitter.emit id, err
