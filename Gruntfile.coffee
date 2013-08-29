module.exports = (grunt) ->

  grunt.initConfig
    watch:
      coffee:
        files: ['app.coffee']
        tasks: ['coffee:server']
      stylus:
        files: ['styles/**/*.styl']
        tasks: ['stylus']

    browserify:
      prod:
        src: ['lib/client.coffee']
        dest: 'public/application.js'
      dev:
        src: ['lib/client.coffee']
        dest: 'public/application.js'
        options:
          debug: true
      options:
        transform: ['coffeeify']

    coffee:
      server:
        expand: on
        cwd: '.'
        src: ['app.coffee']
        dest: '.'
        ext: '.js'

    stylus:
      compile:
        files:
          'public/application.css': ['styles/**/*.styl']

  grunt.loadNpmTasks 'grunt-browserify'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-coffee'
  grunt.loadNpmTasks 'grunt-contrib-stylus'
