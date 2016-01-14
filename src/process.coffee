emitter = require './emitter'

module.exports = class Process

  constructor: (@id, @config, @logger, @runFn) ->

  run: (input) ->
    finish = (results) =>
      state =
        input:
          id: @id
          input: if input.length > 0 then input[0].output else null
          config: @config
        output: results
        runtime: runtime
      input.unshift state
      emitter.emit @id, input

    output = if input.length > 0 then input[0].output else undefined
    before = new Date()
    results = @runFn input, @config, @logger, output
    if results?.then?
      results.then (results) ->
        runtime = new Date() - before
        finish results
    else
      runtime = new Date() - before
      finish results
