emitter = require '../emitter'

module.exports = (id, constants) ->
  run: (input) ->
    constants.fn input
