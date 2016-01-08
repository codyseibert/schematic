module.exports =
  nodes:
    'generator':
      start: true
      type: 'generator'
      constants:
        some: 'object'

    'requester':
      type: 'requester'
      on: 'generator'
      constants:
        url: 'http://google.com'

    'writer':
      type: 'writer'
      on: 'requester'
      constants:
        file: '/Users/cseibert/workspace/schematic/dist/apps/requester/google.html'

    'ender':
      type: 'ender'
      on: 'writer'
      constants:
        fn: -> console.log 'done'
