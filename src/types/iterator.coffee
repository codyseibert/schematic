emitter = require '../emitter'

module.exports = (id, constants) ->
  run: (input) ->
    for obj in input
      emitter.emit id, obj
