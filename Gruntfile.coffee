# Generated on 2013-05-31 using generator-bootstrap-less 2.0.3
"use strict"

generator = require './lib/generator.js'

lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)


# # Globbing
# for performance reasons we're only matching one level down:
# 'test/spec/{,*/}*.js'
# use this if you want to match all subfolders:
# 'test/spec/**/*.js'
module.exports = (grunt) ->

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks

  # configurable paths
  yeomanConfig =
    app: "app"
    dist: "dist"
    partials: "partials"

  grunt.initConfig

    yeoman: yeomanConfig

    "regex-replace":
      foofoo:
        src: ['sources/stations/*.md']
        actions:[
          name: 'RemoveColons'
          search: 'Questions:'
          replace: 'Questions'
          flags: 'gm'
        ]

    panda:
      dev:
        options:
          stripMeta: '````'
          metaDataPath: "<%= yeoman.partials %>/sources.yaml"
          postProcess: generator

        files: [
          expand: true
          cwd: "sources"
          src: ["**/*.md", "!**/template.md", "!**/template/*"]
          dest: "<%= yeoman.partials %>/"
          ext: ".html"
        ]

    # Compile livescript
    livescript:
      compile:
        options:
          bare: false
          prelude: true
        files:
          ["./lib/generator.js": "./lib/generator.ls"]

    watch:
      recess:
        files: ["<%= yeoman.app %>/styles/{,*/}*.less"]
        tasks: ["recess"]

      livereload:
        files: ["sources/**/*.html","<%= yeoman.app %>/**/*.html", "{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css", "{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js", "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"]
        tasks: ["livereload"]

      panda:
        files: ["sources/**/*.md"]
        tasks: ["panda"]

    connect:
      options:
        port: 9000

        # change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, ".tmp"), mountFolder(connect, "app")]

      test:
        options:
          middleware: (connect) ->
            [mountFolder(connect, ".tmp"), mountFolder(connect, "test")]

      dist:
        options:
          middleware: (connect) ->
            [mountFolder(connect, "dist")]

    open:
      server:
        path: "http://localhost:<%= connect.options.port %>"

    clean:
      dist:
        files: [
          dot: true
          src: [".tmp", "<%= yeoman.dist %>/*", "!<%= yeoman.dist %>/.git*"]
        ]

      server: ".tmp"

      partials: "<%= yeoman.partials %>"

    jshint:
      options:
        jshintrc: ".jshintrc"

      all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js", "!<%= yeoman.app %>/scripts/vendor/*", "test/spec/{,*/}*.js"]

    mocha:
      all:
        options:
          run: true
          urls: ["http://localhost:<%= connect.options.port %>/index.html"]

    recess:
      dist:
        options:
          compile: true

        files:
          "<%= yeoman.app %>/styles/main.css": ["<%= yeoman.app %>/styles/main.less"]


    # not used since Uglify task does concat,
    # but still available if needed
    #concat: {
    #      dist: {}
    #    },

    # not enabled since usemin task does concat and uglify
    # check index.html to edit your build targets
    # enable this task if you prefer defining your build targets here
    #uglify: {
    #      dist: {}
    #    },
    rev:
      dist:
        files:
          src: ["<%= yeoman.dist %>/scripts/{,*/}*.js", "<%= yeoman.dist %>/styles/{,*/}*.css", "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}", "<%= yeoman.dist %>/fonts/*"]

    useminPrepare:
      html: "<%= yeoman.app %>/index.html"
      options:
        dest: "<%= yeoman.dist %>"

    usemin:
      html: ["<%= yeoman.dist %>/{,*/}*.html"]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        dirs: ["<%= yeoman.dist %>"]

    imagemin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.{png,jpg,jpeg}"
          dest: "<%= yeoman.dist %>/images"
        ]

    svgmin:
      dist:
        files: [
          expand: true
          cwd: "<%= yeoman.app %>/images"
          src: "{,*/}*.svg"
          dest: "<%= yeoman.dist %>/images"
        ]

    cssmin:
      dist:
        files:
          "<%= yeoman.dist %>/styles/main.css": [".tmp/styles/{,*/}*.css", "<%= yeoman.app %>/styles/{,*/}*.css"]

    htmlmin:
      dist:
        options: {}

        #removeCommentsFromCDATA: true,
        #          // https://github.com/yeoman/grunt-usemin/issues/44
        #          //collapseWhitespace: true,
        #          collapseBooleanAttributes: true,
        #          removeAttributeQuotes: true,
        #          removeRedundantAttributes: true,
        #          useShortDoctype: true,
        #          removeEmptyAttributes: true,
        #          removeOptionalTags: true
        files: [
          expand: true
          cwd: "<%= yeoman.app %>"
          src: "*.html"
          dest: "<%= yeoman.dist %>"
        ]

    copy:
      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: ["*.{ico,txt}", "fonts/*", ".htaccess", "images/{,*/}*.{webp,gif}"]
        ]

      server:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>/bower_components/font-awesome/font/"
          dest: "<%= yeoman.app %>/fonts/"
          src: ["*"]
        ]

    concurrent:
      dist: ["recess", "imagemin", "svgmin", "htmlmin"]


  grunt.renameTask "regarde", "watch"
  grunt.registerTask "server", (target) ->
    return grunt.task.run(["build", "open", "connect:dist:keepalive"])  if target is "dist"
    grunt.task.run ["clean:server", "recess", "copy:server", "dev", "livereload-start", "connect:livereload", "open", "watch"]

  grunt.registerTask "test", ["clean:server", "recess", "copy:server", "connect:test", "mocha"]
  grunt.registerTask "build", ["clean:dist", "copy:server", "useminPrepare", "concurrent", "cssmin", "concat", "uglify", "copy", "rev", "usemin"]
  grunt.registerTask "layout", ["test", "build"]
  grunt.registerTask "dev", ["clean:partials", "livescript", "panda:dev"]
  grunt.registerTask "default", ["dev"]
