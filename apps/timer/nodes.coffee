module.exports =
  nodes:
    'timer':
      type: 'timer'
      start: true
      constants:
        interval: 5000

    'generator':
      type: 'generator'
      on: 'timer'
      constants: 'wtf'

    'ender':
      type: 'ender'
      on: 'generator'
      constants:
        fn: (input) -> console.log input
