"use strict"
path = require 'path'

module.exports = (grunt) ->

  async = grunt.util.async

  compile = (args, cb) ->
    tmpCmd = args.shift!
    filepath = args.pop!
    tmpCwd = path.dirname filepath
    tmpName = path.basename filepath
    args.push tmpName
    tmpArgs = args.slice 0

    if not grunt.option 'verbose'
      grunt.log.write "#{filepath}..."
    child = grunt.util.spawn {cmd: tmpCmd, args: tmpArgs, opts: {cwd: tmpCwd}}, (err, result, code) ->
      success = code == 0
      if code == 127
        return grunt.warn 'You need to have a LaTeX distribution with lualatex installed ' +
          'and in your system PATH for this task to work.'

      # lualatex exits with error code 1 if it finds an error,
      # but it might be that a PDF could be created nevertheless.
      if ( code == 1 and /Output written on/g.test result.stdout )
        success = true

      if not grunt.option 'verbose'
        if success
          grunt.log.ok!
        else
          grunt.log.error!
      else
        if not success
          grunt.log.error "Failed to create file: #{filepath}"
      cb()

    if grunt.option 'verbose'
      child.stdout.pipe(process.stdout)
    child.stderr.pipe(process.stderr)
  

  grunt.registerMultiTask 'latex', 'Compile a LaTeX source file to PDF', ->
    done = @async!
    args = ['lualatex', '--interaction=nonstopmode', '--halt-on-error']
    grunt.log.writeln "Creating pdfs with #{args[0]}:"
    async.forEachSeries( @filesSrc, ( f, cb )  ->
      tmpArgs = args.slice 0
      tmpArgs.push f
      compile tmpArgs, cb
    , done )
  

