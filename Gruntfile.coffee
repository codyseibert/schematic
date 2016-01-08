
module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  config =
    src: 'src'
    dist: 'dist'
    apps: 'apps'

  grunt.initConfig
    config: config

    copy:
      dist:
        files: [
          expand: true
          cwd: "<%= config.apps %>"
          src: [
            '**/*'
            '!**/*.cson'
          ]
          dest: 'dist/apps'
        ]

    cson:
      dist:
        expand: true
        cwd: "<%= config.apps %>"
        src: [
          "**/*.cson"
        ]
        dest: 'dist/apps'
        ext: '.json'

    coffee:
      dist:
        expand: true
        cwd: "<%= config.src %>"
        src : [
          '**/*.coffee'
        ]
        dest: "<%= config.dist %>"
        ext: ".js"
        options:
          bare: false
          sourceMap: false

    clean:
      options:
        force: true
      dist: [
        'dist'
      ]

    watch:
      coffee:
        files: [
          "<%= config.src %>/**/*.coffee"
        ]
        tasks: [
          'coffee:dist',
        ]
      cson:
        files: [
          "<%= config.apps %>/**/*.cson"
        ]
        tasks: [
          'cson:dist',
        ]
      files:
        files: [
          "<%= config.apps %>/**/*"
          "!<%= config.apps %>/**/*.cson"
        ]
        tasks: [
          'copy:dist',
        ]

  grunt.registerTask 'default', [
    'build'
    'watch'
  ]

  grunt.registerTask 'build', [
    'clean'
    'cson:dist'
    'copy:dist'
    'coffee:dist'
  ]

  return
