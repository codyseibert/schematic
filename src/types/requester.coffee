request = require 'request'
_ = require 'underscore'
Promise = require 'bluebird'

module.exports = (chain, config, logger, input) ->
  new Promise (resolve, reject) ->
    request config.url(chain), (err, http, response) ->
      resolve response
