emitter = require '../emitter'

module.exports = (id, constants) ->
  run: ->
    setInterval ->
      emitter.emit id
    , constants.interval
