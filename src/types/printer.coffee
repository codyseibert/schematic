module.exports = (id, constants) ->
  run: (input) ->
    fs = require 'fs'
    fs.readFile input.file, 'utf-8', (err, data) ->
      console.log data
