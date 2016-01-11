emitter = require '../emitter'
request = require 'request'
_ = require 'underscore'

module.exports = (id, constants) ->
  run: (input) ->
    url = if typeof constants.url is 'function' then constants.url(input) else constants.url
    request url, (err, http, response) ->
      output = response
      if !!constants.keepInput
        output =
          response: response
        _.extend output, input
      emitter.emit id, output
