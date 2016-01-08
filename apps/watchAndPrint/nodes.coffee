module.exports =
  nodes:
    'watcher':
      type: 'watcher'
      start: true
      constants:
        file: '/Users/cseibert/workspace/design/dist/apps/watchAndPrint/testing.txt'

    'printer':
      type: 'printer'
      on: 'watcher'
