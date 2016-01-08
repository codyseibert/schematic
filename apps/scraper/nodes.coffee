module.exports =
  nodes:
    'requester':
      start: true
      type: 'requester'
      on: 'generator'
      constants:
        url: 'https://en.wikipedia.org/wiki/Coffee'

    'scraper':
      type: 'scraper'
      on: 'requester'
      constants:
        fn: ($) ->
          $('h3').map (i, el) ->
            text = ""
            $(this).nextUntil('h3').each ->
              text += $(this).text() + '\n'

            title: $(this).text()
            text: text
          .get()

    'iterator':
      type: 'iterator'
      on: 'scraper'

    'writer':
      type: 'writer'
      on: 'iterator'
      constants:
        json: true
        folder: '/Users/cseibert/workspace/schematic/dist/apps/json/scraper'
        file: (input) -> "#{input.title}.json"
