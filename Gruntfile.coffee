_ = require('lodash')
child_process = require('child_process')

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig(
    pkg: grunt.file.readJSON('package.json')

    modernizr: {
      dist: {
        "devFile" : "node_modules/grunt-modernizr/lib/modernizr-dev.js",

        "outputFile" : "build/modernizr-custom.js",

        "extra" : {
            "shiv" : true,
            "printshiv" : false,
            "load" : true,
            "mq" : false,
            "cssclasses" : true
        },

        "extensibility" : {
            "addtest" : false,
            "prefixed" : false,
            "teststyles" : false,
            "testprops" : false,
            "testallprops" : false,
            "hasevents" : false,
            "prefixes" : false,
            "domprefixes" : false
        },

        "uglify" : true,

        "tests" : [],

        "parseFiles" : true,

        "matchCommunityTests" : false,

        "customTests" : []
      }

    },
  )

  require('./grunt/build')(grunt)
  require('./grunt/server')(grunt)
  require('./grunt/test')(grunt)
  require('./grunt/watch')(grunt)

  grunt.registerTask('default', ['build'])

  grunt.registerTask('build', ['clean', 'browserify:quill', 'browserify:tandem', 'uglify', 'concat', 'coffee:all', 'jade', 'stylus'])

  grunt.initConfig

  # TODO is there a better way to do this...
  grunt.registerTask('dev', 'All the tasks for Quill development', ->
    done = this.async()
    child_process.spawn('grunt', ['watch'], { stdio: 'inherit'})
    child_process.spawn('grunt', ['browserify:quill-watchify'], { stdio: 'inherit'})
    child_process.spawn('grunt', ['browserify:quill-exposed-watchify'], { stdio: 'inherit'})
    child_process.spawn('grunt', ['test:karma'], { stdio: 'inherit'})
    child_process.spawn('grunt', ['connect:server'], { stdio: 'inherit' })
  )

  grunt.registerTask('test', ['karma:test'])

  grunt.registerTask('test:karma', ['karma:karma'])
  grunt.registerTask('test:unit', ['karma:test'])
  grunt.registerTask('test:unit:remote', ['karma:remote-mac', 'karma:remote-windows', 'karma:remote-linux', 'karma:remote-mobile', 'karma:remote-legacy'])

  grunt.registerTask('test:coverage', ['coffee:src', 'shell:instrument', 'browserify:quill', 'karma:coverage', 'clean:coffee', 'clean:coverage', 'browserify:quill'])
  grunt.task.loadNpmTasks('grunt-modernizr');