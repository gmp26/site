# Generated on 2013-05-31 using generator-bootstrap-less 2.0.3
"use strict"

expandMetadata = require './lib/expandMetadata.js'
generateHtml = require './lib/generateHtml.js'
generatePrintables = require './lib/generatePrintables.js'
tubemap = require './lib/tubemap.js'
siteUrl = require './lib/siteUrl.js'
clearance = require './lib/clearance.js'
isolate = require './lib/isolate.js'
integrate = require './lib/integrate.js'
lrSnippet = require("grunt-contrib-livereload/lib/utils").livereloadSnippet
latex = require './lib/recursiveLatex.js'
path = require 'path'
lastUpdated = (require './lib/lastUpdated.js')

# Dummy files to make grunt-newer play nicely with expandMetadata, lastUpdated and generateHtml
# This is a catch-all of src files which require rerunning of the above tasks on modification
dummyFiles = [
  src: [
    "<%= yeoman.sources %>/**/*.md" 
    "!<%= yeoman.sources %>/**/template.md" 
    "!<%= yeoman.sources %>/**/template/*"
    "!<%= yeoman.sources %>/Temporary/*"
    "!<%= yeoman.sources %>/Temporary/**/*.md"
    "lib/*.ls"
    "layouts/*.html"
  ]
] 

mountFolder = (connect, dir) ->
  connect.static path.resolve(dir)

module.exports = (grunt) ->

  _ = grunt.util._

  pass2 = (require './lib/pass2.js')(grunt, path)

  # load all grunt tasks
  require("matchdep").filterDev("grunt-*").forEach grunt.loadNpmTasks
  # grunt.loadNpmTasks 'grunt-mocha-test'

  # Give grunt shell script capabilities
  # grunt.loadNpmTasks 'grunt-shell'

  # configurable paths
  yeomanConfig =
    appSources: "app-sources" # static sources to be copied to app
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
        
    # shell:
    #   modifiedDate:
    #     command:'git log -1 --pretty=format:%ad --date=short G2_RT2'
    #     options:
    #       callback:modifiedDateCallback

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

    # find last modified date
    lastUpdated:
      resources:
        # Dummy files to make newer play nicely!
        files: dummyFiles
        options: null
      examQuestions:
        # Dummy files to make newer play nicely!
        files: dummyFiles
        options: null

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
          # The dest: is a hack to get newer to play nicely - it needs to be the same as cwd
          dest: "<%= yeoman.sources %>"
        ]
      pass2html:
        options:
          process: pass2.htmlProcess
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
          pandocOptions: "-f markdown+raw_tex+fenced_code_blocks -t latex --listings --smart"
          process: pass2.printableProcess
          stripMeta: '````'
          metaReplace: "<%= yeoman.sources %>"
          metaReplacement: "sources"
        files: [
          expand: true
          cwd: "<%= yeoman.sources %>"
          #  src: ["resources/widget_lib/lodash.md"]
          src: ["**/*.md", "!**/template.md", "!**/template/*", "!Temporary/*", "!Temporary/**/*.md"]
          dest: "<%= yeoman.partials %>/printables/"
          ext: ".tex"
        ]

      dev:
        options:
          stripMeta: '````'
          metaDataPath: "<%= yeoman.partials %>/sources.yaml"
          metaDataVar: "metadata"
          metaReplace: "<%= yeoman.sources %>"
          metaReplacement: "sources"


        files: "<%=pass1Files%>"

    latex:
      test:
        src: ["<%= yeoman.partials %>/printables/stations/G2.printable.tex", "<%= yeoman.partials %>/printables/resources/widget_lib/*.printable.tex"]
      printables:
        # src: ["<%= yeoman.partials %>/printables/resources/widget_lib/lodash.printable.tex"]
        src: ["<%= yeoman.partials %>/printables/**/*.printable.tex"]

    # Validate, weed, and expand metadata
    expandMetadata:
      task:
        # Dummy files to make newer play nicely!
        files: dummyFiles
        options: null

    # Generate pages using layouts and partial HTML, guided by expanded metadata
    generateHtml:
      task:
        # Dummy files to make newer play nicely!
        files: dummyFiles
        options: null

    # Generate printable pdfs using layouts and partial tex, guided by expanded metadata
    generatePrintables:
      task:
        # Dummy files to make newer play nicely!
        files: dummyFiles
        options: null

    # Create a tubemap from metadata
    tubemap:
      svg:
        files: [
          dest: "<%= yeoman.appSources %>/images/tubeMap.svg"
          src: "<%= yeoman.partials %>/expanded.yaml"
        ]
      png:
        files: [
          dest: "<%= yeoman.appSources %>/images/tubeMap.png"
          src: "<%= yeoman.partials %>/expanded.yaml"
        ]

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
        files: ["<%= yeoman.appSources %>/styles/{,*/}*.less"]
        tasks: ["newer:recess"]

      livereload:
        files: [
          "<%= yeoman.app %>/**/*.html"
          "<%= yeoman.app %>/**/*.html"
          "{.tmp,<%= yeoman.app %>}/styles/{,*/}*.css"
          "{.tmp,<%= yeoman.app %>}/scripts/{,*/}*.js"
          "<%= yeoman.app %>/images/{,*/}*.{png,jpg,jpeg,gif,webp,svg}"
        ]
        # watch can now handle livereload!
        options:
          livereload: true
        

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

      scripts:
        files: [
          "<%= yeoman.appSources %>/scripts/*"
          "!<%= yeoman.appSources %>/scripts/map.js"
        ]
        tasks: [
          "newer:copy:assets"
        ]

      # The map.js script has metadata created by generateHtml
      # TODO: possibly refactor this out into its own task?
      mapScript: 
        files: [
          "<%= yeoman.appSources %>/scripts/map.js"
        ]
        tasks: [
          "expandMetadata"
          "generateHtml"
        ]

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
          src: [".tmp", "<%= yeoman.dist %>/*"]
        ]

      server: ".tmp"

      partials: "<%= yeoman.partials %>"

      newer: 
        files: [
          dot: true
          src: ["node_modules/grunt-newer/.cache/**"]
        ]

      app: 
        files: [
          src: [
            "<%= yeoman.app %>"
          ]
        ]

    # jshint:
    #   options:
    #     jshintrc: ".jshintrc"

    #   all: ["Gruntfile.js", "<%= yeoman.app %>/scripts/{,*/}*.js", "!<%= yeoman.app %>/scripts/vendor/*", "test/{,*/}*.js"]

    recess:
      dist:
        options:
          compile: true

        files:
          "<%= yeoman.app %>/styles/main.css": ["<%= yeoman.appSources %>/styles/main.less"]


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
          dot: true
          cwd: "<%= yeoman.appSources %>"
          src: ["**/*", "*"]
          dest: "<%= yeoman.app %>"
        ,
          expand: true
          cwd: "<%= yeoman.sources %>/resources"
          # pick up swfs, svgs and subfolders too
          src: ["*/*.png", "*/*.svg", "*/*.jpg", "*/*.gif", "*/*.swf", "*/*/**"]
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
            "bower_components/**/*.js"  # can we restrict to *.min.js in dist?
            "scripts/map.js"
            "scripts/underscore-min.js"
            "resources/*/*.gif"
            "resources/*/*.jpg"
            "resources/*/*.png"
            "resources/*/*.svg"
            "resources/*/*.swf"
            "resources/*/*.pdf"
            "resources/*/*/**"
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

      printables:
        files: [
          expand: true
          cwd: "<%= yeoman.partials %>/printables"
          src: "**/*.printable.pdf"
          dest: "<%= yeoman.app %>"
          rename: (dest, matchedSrcPath) -> (path.join dest, matchedSrcPath).replace ".printable.pdf", ".pdf"
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

  # set some globals
  grunt.template.addDelimiters 'CMEP', '<:', ':>'

  # register latex task
  latex grunt

  # register expandMetadata task
  expandMetadata grunt

  # register generateHtml task
  generateHtml grunt

  # register generatePrintables task
  generatePrintables grunt
  
  # register tubemap task
  tubemap grunt

  # register siteUrl task
  siteUrl grunt

  # register clearance task
  clearance grunt

  # register isolate task
  isolate grunt

  # register integrate task
  integrate grunt

  # register lastUpdated task
  lastUpdated grunt

  # register stripMeta task (Unused ???)
  # stripMeta grunt

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
        "siteUrl:dev"
        "recess"
        "copy:server"
        "dev"
        # livereload now handled in watch
        "connect:livereload"
        "open"
        "watch"
      ])

  grunt.registerTask "test", [
    "clean:app"
    "clean:test"
    "dev:html"
    # "lsc"
    # "panda:pass1"
    # "expandMetadata"
    # "lastUpdated"
    # "panda:pass2html"
    # "copy:assets"
    # "generateHtml"

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
    "lsc"
    "clearance"
    "panda:pass1"
    "expandMetadata"
    "lastUpdated"
    "tubemap:svg"
    "siteUrl:dist"
    "panda:pass2printables"
    "generatePrintables"
    "latex:printables"
    "copy:printables"
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
    "copy:dist"
    "usemin"
  ]

  grunt.registerTask "dev", (listOfTargets) ->
    # Make the targets variable hold an array of strings representing desired targets.
    # Assume that the passed parameter is a comma separated list (with no spaces)
    # of target strings. 
    # "all" is a special value that is replaced by all the targets
    # "quick" is a special value which does a small amout of the latex
    switch listOfTargets
      when undefined then targets = ["html"]
      when "all" then targets = ["html", "printables"]
      when "quick" then targets = ["quick"] 
      else targets = listOfTargets.split ","

    grunt.log.writeln "Developing for targets:"
    _.each targets, (value, index, collection) -> grunt.log.writeln "  " + value

    # tasks common to all targets
    grunt.task.run ([ 
      "newer:lsc" 
      "clearance" # no newer implementation needed
      "newer:panda:pass1" 
      "newer:expandMetadata"
      "newer:lastUpdated" 
    ])
    if _.contains(targets, "html")
      grunt.task.run([
        "newer:tubemap:svg" 
        "newer:panda:pass2html" 
        "newer:copy:assets" 
        "newer:generateHtml" 
      ])
    if _.contains(targets, "printables")
      grunt.task.run([
        "newer:panda:pass2printables"
        "newer:generatePrintables"
        "newer:latex:printables"
        "newer:copy:printables"
      ])
    else if _.contains(targets, "quick")
      grunt.task.run([
        "panda:pass2printables"
        "generatePrintables"
        "latex:test"
        "copy:printables"
      ])

  grunt.registerTask "default", ["dev"]