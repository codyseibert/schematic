moment = require 'moment'

module.exports =
  nodes:
    'generator':
      start: true
      type: 'generator'
      config:
        ticker: 'GOOG'

    'requester':
      type: 'requester'
      on: 'generator'
      config:
        url: (chain) -> "http://ichart.finance.yahoo.com/table.csv?s=#{chain[0].output.ticker}"

    'csv-to-json':
      type: 'csv-to-json'
      on: 'requester'

    'converter':
      type: 'script'
      on: 'csv-to-json'
      config:
        fn: (chain, config, logger, input) ->
          headers = input.shift()
          ret = []
          input.map (entry) ->
            obj = {}
            for key, i in headers
              obj[key] = entry[i]
            obj

    'sort':
      type: 'script'
      on: 'converter'
      config:
        fn: (chain, config, logger, input) ->
          input.sort (a, b) ->
            moment(a.Date).valueOf() - moment(b.Date).valueOf()

    'writer':
      type: 'writer'
      on: 'sort'
      config:
        folder: (chain) -> "/Users/cseibert/workspace/schematic/dist/apps/stocks"
        file: (chain) -> "#{chain[4].output.ticker}.csv"
