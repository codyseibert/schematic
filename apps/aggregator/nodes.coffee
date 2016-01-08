module.exports =
  nodes:
    'generator':
      start: true
      type: 'generator'
      constants: [
        'a'
        'b'
        'c'
        'd'
      ]

    'splitter':
      type: 'splitter'
      on: 'generator'

    'modifier':
      type: 'modifier'
      on: 'splitter'
      constants:
        fn: (obj) ->
          obj + '123'

    'aggregator':
      type: 'aggregator'
      on: 'modifier'

    'ender':
      type: 'ender'
      on: 'aggregator'
      constants:
        fn: (input) -> console.log input
