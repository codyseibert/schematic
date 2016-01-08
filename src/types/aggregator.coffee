emitter = require '../emitter'
_ = require 'underscore'

module.exports = (id, constants) ->
  uuids = {}

  run: (input) ->
    uuid = input.uuid
    u = uuids[uuid] ?=
      remaining: input.total
      collection: []
    u.collection.push _.omit input, ['total', 'uuid']
    u.remaining--
    if u.remaining <= 0
      emitter.emit id, u.collection
      delete uuids[uuid]
