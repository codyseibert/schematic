emitter = require '../emitter'
cheerio = require 'cheerio'

module.exports = (id, constants) ->
  run: (input) ->
    $ = cheerio.load input.response
    emitter.emit id, constants.fn $
