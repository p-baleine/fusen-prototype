module.exports = (grunt) ->

  grunt.initConfig
    watch:
      coffee:
        files: ['app.coffee']
        tasks: ['coffee:server']
      browserify:
        files: ['lib/client/**/*.coffee']
        tasks: ['browserify:dev']
      stylus:
        files: ['styles/**/*.styl']
        tasks: ['stylus']

    browserify:
      prod:
        src: ['lib/client/boot.coffee']
        dest: 'public/application.js'
      dev:
        src: ['lib/client/boot.coffee']
        dest: 'public/application.js'
        options:
          debug: true
      unit:
        src: ['spec/client/spec-harness.coffee']
        dest: 'public/application.spec.js'
        options:
          debug: true
      options:
        transform: ['coffeeify', 'node-underscorify']
        shim:
          jQuery:
            path: 'node_modules/jquery-browserify/lib/jquery.js'
            exports: '$'
          SVG:
            path: 'vendor/bower_components/svg.js/dist/svg.js'
            exports: 'SVG'
          SVGDraggable:
            path: 'vendor/svg.draggable.js'
            exports: 'SVG'
          SVGFilter:
            path: 'vendor/svg.filter.js'
            exports: 'SVG'

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

  grunt.registerTask 'heroku:production', [
    'coffee:server'
    'browserify:dev'
    'stylus'
  ]