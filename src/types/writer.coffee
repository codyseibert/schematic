fs = require 'fs'
Promise = require 'bluebird'

module.exports = (chain, config, logger, input) ->
  folder = config.folder? chain
  file = config.file? chain
  path = if folder? then "#{folder}/#{file}" else file
  fs.writeFileSync path, JSON.stringify input, null, 2
