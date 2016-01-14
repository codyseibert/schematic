parse = require 'csv-parse'
_ = require 'underscore'
Promise = require 'bluebird'

module.exports = (chain, config, logger, input) ->
  new Promise (resolve, reject) ->
    parse input, (err, json) ->
      resolve json
