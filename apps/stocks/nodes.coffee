module.exports =
  nodes:
    'generator':
      start: true
      type: 'generator'
      config:
        ticker: 'GOOG'

    'print':
      type: 'script'
      on: 'generator'
      config:
        fn: (chain, config, logger, input) ->
          logger.trace 'print'
          logger.trace "chain:  #{JSON.stringify chain, null, 2}"

    'end':
      type: 'script'
      on: 'print'
      config:
        fn: (chain, config, logger, input) ->
          logger.trace 'end'
          logger.trace "chain:  #{JSON.stringify chain, null, 2}"

    # 'requester':
    #   type: 'requester'
    #   on: 'generator'
    #   config:
    #     keepInput: true
    #     url: (input) -> "http://ichart.finance.yahoo.com/table.csv?s=#{input.ticker}"
    #
    # 'parser':
    #   type: 'parser'
    #   on: 'requester'
    #   config:
    #     keepInput: true
    #     url: (input) -> "http://ichart.finance.yahoo.com/table.csv?s=#{input.ticker}"
    #
    # 'writer':
    #   type: 'writer'
    #   on: 'requester'
    #   config:
    #     folder: "/Users/cseibert/workspace/schematic/dist/apps/stocks"
    #     file: (input) -> "#{input.ticker}.csv"
