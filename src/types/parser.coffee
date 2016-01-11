emitter = require '../emitter'
parse = require 'csv-parse'
_ = require 'underscore'

module.exports = (id, constants) ->
  run: (input) ->
    output = parse input
    if !!constants.keepInput
      _.extend output, parsed: parsed
    emitter.emit id, output
