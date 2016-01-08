emitter = require '../emitter'

module.exports = (id, constants) ->
  run: ->
    emitter.emit id, constants
