module.exports =
  nodes:
    'generator':
      start: true
      type: 'generator'
      constants:
        some: 'object'

    'modifier':
      type: 'modifier'
      on: 'generator'
      constants:
        fn: (obj) ->
          obj.test = '1234'
          obj

    'ender':
      type: 'ender'
      on: 'modifier'
      constants:
        fn: (input) -> console.log input
