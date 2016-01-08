
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
            '!**/*.coffee'
          ]
          dest: 'dist/apps'
        ]

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
      apps:
        expand: true
        cwd: "<%= config.apps %>"
        src : [
          '**/*.coffee'
        ]
        dest: "<%= config.dist %>/apps"
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
      apps:
        files: [
          "<%= config.apps %>/**/*.coffee"
        ]
        tasks: [
          'coffee:apps',
        ]
      files:
        files: [
          "<%= config.apps %>/**/*"
          "!<%= config.apps %>/**/*.coffee"
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
    'copy:dist'
    'coffee:apps'
    'coffee:dist'
  ]

  return
