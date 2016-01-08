path = require 'path'
module.exports =
  nodes:
    'requester':
      start: true
      type: 'requester'
      constants:
        url: 'https://www.reddit.com/r/EarthPorn'

    'scraper':
      type: 'scraper'
      on: 'requester'
      constants:
        fn: ($) ->
          $('div[data-subreddit="EarthPorn"] a.title').map (i, el) ->
            $(this).attr('href')
          .get()

    'iterator':
      type: 'iterator'
      on: 'scraper'

    'images':
      type: 'requester'
      on: 'iterator'
      constants:
        url: (input) ->
          console.log input
          input

    'writer':
      type: 'writer'
      on: 'images'
      constants:
        folder: '/Users/cseibert/earth'
        file: (input) -> "#{path.basename input.url}"
