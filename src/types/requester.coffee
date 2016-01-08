emitter = require '../emitter'
request = require 'request'

module.exports = (id, constants) ->
  run: (input) ->
    url = if typeof constants.url is 'function' then constants.url(input) else constants.url
    request url, (err, http, response) ->
      emitter.emit id,
        url: url
        response: response
