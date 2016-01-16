fs = require 'fs'
path = require 'path'
Promise = require 'bluebird'

module.exports = (chain, config, logger, input) ->
  folder = path.resolve __dirname, '..', 'workspace'
  file = config.file? chain
  path = if folder? then "#{folder}/#{file}" else file
  fs.writeFileSync path, JSON.stringify input, null, 2
