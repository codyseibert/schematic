emitter = require '../emitter'
uuid = require 'uuid'

module.exports = (id, constants) ->
  run: (input) ->
    uu = uuid.v4()
    for obj in input
      emitter.emit id,
        total: input.length
        uuid: uu
        obj: obj
