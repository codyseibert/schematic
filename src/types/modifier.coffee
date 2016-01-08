emitter = require '../emitter'
_ = require 'underscore'

module.exports = (id, constants) ->
  run: (input) ->
    modified = input
    if not _.isObject(input) or not input.obj?
      modified = constants.fn modified
    else
      modified.obj = constants.fn input.obj
    emitter.emit id, modified
