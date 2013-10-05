# Generated on 2013-05-31 using generator-bootstrap-less 2.0.3
"use strict"

expandMetadata = require './lib/expandMetadata.js'
generateHtml = require './lib/generateHtml.js'
generatePrintables = require './lib/generatePrintables.js'
tubemap = require './lib/tubemap.js'
clearance = require './lib/clearance.js'
isolate = require './lib/isolate.js'
integrate = require './lib/integrate.js'
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
latex = require './lib/recursiveLatex.js'


mountFolder = (connect, dir) ->
  connect.static require("path").resolve(dir)

module.exports = (grunt) ->

  pass2Utils = (require './lib/pass2Utils.js')(grunt)
  #examQuestions = (require './lib/examQuestions.js')(grunt)

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks
  grunt.loadNpmTasks 'grunt-mocha-test'

  # configurable paths
  yeomanConfig =
    app: "app"  # document root of development site 
    dist: "dist" # document root of production site
    content: "../CMEP-sources"  # the real sources
    samples: "sources"          # sample and test case sources
    sources: "sources"    # the active source path which can switch between content and samples
    partials: "partials"  # a working directory for content to be assembled in

  grunt.initConfig

    yeoman: yeomanConfig

    # use as needed to fix stuff
    "regex-replace":
      foofoo:
        src: ['<%= yeoman.sources %>/stations/*.md']
        actions:[
          name: 'RemoveColons'
          search: 'Questions:'
          replace: 'Questions'
          flags: 'gm'
        ]

    # Unused now?
    # stripMeta:
    #   dev:
    #     options:
    #       process: false
    #       stripMeta: '````'
    #       metaDataPath: "<%= yeoman.partials %>/sources.yaml"
    #       strippedPath: "<%= yeoman.partials %>/stripped.yaml"
    #       metaDataVar: "metadata"
    #       metaReplace: "<%= yeoman.sources %>"
    #       metaReplacement: "sources"
    #     files: "<%= pass1Files %>"


    # compile HTML and tex, and aggregate metadata
    panda:
      pass1:
        options:
          process: false
          stripMeta: '````'
          metaDataPath: "<%= yeoman.partials %>/sources.yaml"
          metaDataVar: "metadata"
          metaReplace: "<%= yeoman.sources %>"
          metaReplacement: "sources"
          metaOnly: true
        files: [
          expand: true
          cwd: "<%= yeoman.sources %>"
          src: ["**/*.md", "!**/template.md", "!**/template/*", "!Temporary/*", "!Temporary/**/*.md"]
        ]
      pass2html:
        options:
          process: pass2Utils
          stripMeta: '````'
          metaReplace: "<%= yeoman.sources %>"
          metaReplacement: "sources"
        files: [
          expand: true
          cwd: "<%= yeoman.sources %>"
          src: ["**/*.md", "!**/template.md", "!**/template/*", "!Temporary/*", "!Temporary/**/*.md"]
          dest: "<%= yeoman.partials %>/html/"
          ext: ".html"
        ]
      pass2printables:
        options:
          process: pass2Utils
          stripMeta: '````'
          metaReplace: "<%= yeoman.sources %>"
          metaReplacement: "sources"
        files: [
          expand: true
          cwd: "<%= yeoman.sources %>"
          src: ["**/*.md", "!**/template.md", "!**/template/*", "!Temporary/*", "!Temporary/**/*.md"]
          dest: "<%= yeoman.partials %>/printables/"
          ext: ".tex"
        ]

      dev:
        options:
          process:
            data: {
              #examQuestions: (s) -> examQuestions(s)
            }
          stripMeta: '````'
          metaDataPath: "<%= yeoman.partials %>/sources.yaml"
          metaDataVar: "metadata"
          metaReplace: "<%= yeoman.sources %>"
          metaReplacement: "sources"


        files: "<%=pass1Files%>"

    latex:
      test:
        src: ["<%= yeoman.partials %>/printables/stations/G2.printable.tex", "<%= yeoman.partials %>/printables/resources/G2_RT3/*.printable.tex"]
      printables:
        src: ["<%= yeoman.partials %>/printables/**/*.printable.tex"]

    # Validate, weed, and expand metadata
    expandMetadata:
      options: null

    # Generate pages using layouts and partial HTML, guided by expanded metadata
    generateHtml:
      options: null

    # Generate printable pdfs using layouts and partial tex, guided by expanded metadata
    generatePrintables:
      options: null

    # Create a tubemap from metadata
    tubemap:
      svg:
        files:
          "app/images/tubeMap.svg": "<%= yeoman.partials %>/expanded.yaml"
      png:
        files:
          "app/images/tubeMap.png": "<%= yeoman.partials %>/expanded.yaml"

    # Compile livescript
    # livescript:
    #   compile:
    #     options:
    #       bare: false
    #       prelude: true
    #     files: [
    #       expand: true
    #       cwd: "lib"
    #       src: ["**/*.ls"]
    #       dest: "./lib/"
    #       ext: ".js"
    #     ,
    #       expand: true
    #       src: ["test/*.ls"]
    #       dest: "."
    #       ext: ".js"
    #     ]

    lsc:
      options:
        bare: false
      compile:
        files: [
          expand: true
          cwd: "lib"
          src: ["**/*.ls"]
          dest: "./lib/"
          ext: ".js"
        ,
          expand: true
          src: ["test/*.ls"]
          dest: "."
          ext: ".js"
        ]


    # Watch 
    watch:
      recess:
        files: ["<%= yeoman.app %>/styles/{,*/}*.less"]
        tasks: ["recess"]

      livereload:
        files: ["<%= yeoman.app %>/**/*.html","<%= yeoman.app %>/**/*.html", "{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css", "{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js", "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"]
        tasks: ["livereload"]

      dev:
        files: [
          "lib/*.ls"
          "layouts/*.html"
          "<%= yeoman.sources %>/index.md"
          "<%= yeoman.sources %>/privacy.md"
          "<%= yeoman.sources %>/cookies.md"
          "<%= yeoman.sources %>/map.md"
          "<%= yeoman.sources %>/pervasiveIdeasHome.md"
          "<%= yeoman.sources %>/guides/*.md"
          "<%= yeoman.sources %>/lines/*.md"
          "<%= yeoman.sources %>/pervasiveIdeas/*.md"
          "<%= yeoman.sources %>/examQuestions/*/*"
          "<%= yeoman.sources %>/resources/*/*"
          "<%= yeoman.sources %>/resourceTypes/*.md"
          "<%= yeoman.sources %>/stations/*.md"
        ]
        tasks: ["dev"]

    connect:
      options:
        port: 9000

        # change this to '0.0.0.0' to access the server from outside
        hostname: "localhost"

      livereload:
        options:
          middleware: (connect) ->
            [lrSnippet, mountFolder(connect, ".tmp"), mountFolder(connect, "app")]

      # test:
      #   options:
      #     middleware: (connect) ->
      #       [mountFolder(connect, ".tmp"), mountFolder(connect, "test")]

      dist:
        options:
          middleware: (connect) ->
            [mountFolder(connect, "dist")]

    open:
      server:
        path: "http://localhost:<%= connect.options.port %>"

    clean:
      test:
        files: [
          dot: true
          src: "test/actual/**/*"
        ]

      dist:
        files: [
          dot: true
          src: [".tmp", "<%= yeoman.dist %>/*", "!<%= yeoman.dist %>/.git*"]
        ]

      server: ".tmp"

      partials: "<%= yeoman.partials %>"

      app: 
        files: [
          src: [
            "<%= yeoman.app %>/guides/*"
            "<%= yeoman.app %>/lines/*"
            "<%= yeoman.app %>/pervasiveIdeas/*"
            "<%= yeoman.app %>/resources/**/*"
            "<%= yeoman.app %>/resourceTypes/*"
            "<%= yeoman.app %>/stations/*"
            "<%= yeoman.app %>/resourceTypes/*"
          ]
        ]

    jshint:
      options:
        jshintrc: ".jshintrc"

      all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js", "!<%= yeoman.app %>/scripts/vendor/*", "test/{,*/}*.js"]

    recess:
      dist:
        options:
          compile: true

        files:
          "<%= yeoman.app %>/styles/main.css": ["<%= yeoman.app %>/styles/main.less"]


    # not used since Uglify task does concat,
    # but still available if needed
    #concat:
    #  dist:

    # uglify:
    #  dist:
    #   options:
    #     compress: true
    #   files:
    #     "./dist/scripts/vendor/bootstrap.js": [
    #       "./app/bower_components/bootstrap/js/bootstrap-affix.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-alert.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-dropdown.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-tooltip.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-modal.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-transition.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-button.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-popover.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-typeahead.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-carousel.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-scrollspy.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-collapse.js"
    #       "./app/bower_components/bootstrap/js/bootstrap-tab.js"
    #     ]
    #     "./dist/scripts/vendor/modernizr.js": [
    #       "./app/bower_components/jquery/jquery.js"
    #       "./app/bower_components/modernizr/modernizr.js"
    #     ]
    #     "./dist/scripts/main.js": [
    #       ".app/scripts/main.js"
    #     ]
    # rev:
    #   dist:
    #     files:
    #       src: [
    #         "<%= yeoman.dist %>/scripts/{,*/}*.js"
    #         "<%= yeoman.dist %>/styles/{,*/}*.css"
    #         "<%= yeoman.dist %>/images/{,*/}*.{png,jpg,jpeg,gif,webp}"
    #         "<%= yeoman.dist %>/fonts/*"
    #       ]


    #
    # UseminPrepare and usemin work, but are hardly optimal
    # Need to do this with dist specific layouts & templates 
    #
    useminPrepare:
      html: [
        "<%= yeoman.app %>/index.html"
      ]
      options:
        dest: "<%= yeoman.dist %>"

    usemin:
      html: [
        "<%= yeoman.dist %>/**/*.html"
      ]
      css: ["<%= yeoman.dist %>/styles/{,*/}*.css"]
      options:
        basedir: "<%= yeoman.dist %>"
        dirs: [
          "<%= yeoman.dist %>"
        ]

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
          "<%= yeoman.dist %>/styles/main.css": [
             "<%= yeoman.app %>/styles/{,*/}*.css"
          ]

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
          src: ["{,*/}*.html", "resources/*/*.html"]
          dest: "<%= yeoman.dist %>"
        ]

    copy:

      assets:
        files: [
          expand: true
          cwd: "<%= yeoman.sources %>/resources"
          src: ["*/*.png", "*/*.svg", "*/*.jpg", "*/*.gif", "*/*.swf"]
          dest: "<%= yeoman.app %>/resources"
        ]

      dist:
        files: [
          expand: true
          dot: true
          cwd: "<%= yeoman.app %>"
          dest: "<%= yeoman.dist %>"
          src: [
            "*.{ico,txt}"
            "fonts/*"
            ".htaccess"
            "resources/*/*.gif"
            "resources/*/*.jpg"
            "resources/*/*.png"
          ]
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

    mochaTest:
      sources:
        options:
          reporter: 'spec'
        files: [
          src: [
            "test/*.js" 
            "!test/test_integrate.js"
            "!test/test_stripMeta.js"
          ]
        ]
      integrate:
        options:
          reporter: 'spec'
        files: [
          src: "test/test_integrate.js"
        ]
      stripMeta:
        options:
          reporter: 'spec'
        files: [
          src: [
            "test/test_isolate.js"
            "test/test_stripMeta.js"
          ]
        ]

  #
  latex grunt

  # register expandMetadata task
  expandMetadata grunt

  # register generateHtml task
  generateHtml grunt

  # register generatePrintables task
  generatePrintables grunt
  
  # register tubemap task
  tubemap grunt

  # register clearance task
  clearance grunt

  # register isolate task
  isolate grunt

  # register integrate task
  integrate grunt

  # register stripMeta task (Unused ???)
  # stripMeta grunt


  grunt.renameTask "regarde", "watch"

  grunt.registerTask "server", (target) ->
    if target is "dist"
      grunt.task.run([
        "build"
        "open"
        "connect:dist:keepalive"
      ])
    else
      grunt.task.run ([
        "clearance"
        "clean:server"
        "recess"
        "copy:server"
        "dev"
        "livereload-start"
        "connect:livereload"
        "open"
        "watch"
      ])

  grunt.registerTask "test", [
    "clean:app"
    "clean:test"
    "lsc"
    "panda:pass1"
    "expandMetadata"
    "panda:pass2html"
    "generateHtml"
    "mochaTest:sources"
  ]

  grunt.registerTask "units", [
    "clean:app"
    "clean:test"
    "lsc"
    "integrate"
    "mochaTest:integrate"
    "isolate:EQ1,G2"
    "stripMeta"
    "mochaTest:stripMeta"
  ]

  grunt.registerTask "build", [
    "clearance"
    "lsc"
    "panda:pass1"
    "expandMetadata"
    "tubemap:png"
    "panda:pass2html"
    "copy:assets"
    "generateHtml"
    "clean:dist"
    "copy:server"
    "useminPrepare"
    "concurrent"
    "cssmin"
    "concat"
    "uglify"
    "copy"
    "usemin"
  ]

  grunt.registerTask "dev", [
    "lsc"
    "panda:pass1"
    "expandMetadata"
    "tubemap:png"
    "panda:pass2html"
    "panda:pass2printables"
    "copy:assets"
    "generateHtml"
    "generatePrintables"
  ]

  grunt.registerTask "default", ["dev"]
