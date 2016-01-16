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

    'derivative':
      type: 'script'
      on: 'sort'
      config:
        fn: (chain, config, logger, input) ->
          input[0].Derivative = 0
          for i in [1...input.length]
            input[i].Derivative = input[i].Close+0 - input[i-1].Close+0
          input

    'writer':
      type: 'writer'
      on: 'derivative'
      config:
        file: (chain) -> "#{chain[5].output.ticker}.csv"
