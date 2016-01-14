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

    'writer':
      type: 'writer'
      on: 'converter'
      config:
        folder: (chain) -> "/Users/cseibert/workspace/schematic/dist/apps/stocks"
        file: (chain) -> "#{chain[3].output.ticker}.csv"
