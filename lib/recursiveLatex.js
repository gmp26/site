(function(){
  "use strict";
  var path;
  path = require('path');
  module.exports = function(grunt){
    var async, compile;
    async = grunt.util.async;
    compile = function(args, cb){
      var tmpCmd, filepath, tmpCwd, tmpName, tmpArgs, child;
      tmpCmd = args.shift();
      filepath = args.pop();
      tmpCwd = path.dirname(filepath);
      tmpName = path.basename(filepath);
      args.push(tmpName);
      tmpArgs = args.slice(0);
      if (!grunt.option('verbose')) {
        grunt.log.write(filepath + "...");
      }
      child = grunt.util.spawn({
        cmd: tmpCmd,
        args: tmpArgs,
        opts: {
          cwd: tmpCwd
        }
      }, function(err, result, code){
        var success;
        success = code === 0;
        if (code === 127) {
          return grunt.warn('You need to have a LaTeX distribution with lualatex installed ' + 'and in your system PATH for this task to work.');
        }
        if (code === 1 && /Output written on/g.test(result.stdout)) {
          success = true;
        }
        if (!grunt.option('verbose')) {
          if (success) {
            grunt.log.ok();
          } else {
            grunt.log.error();
          }
        } else {
          if (!success) {
            grunt.log.error("Failed to create file: " + filepath);
          }
        }
        return cb();
      });
      if (grunt.option('verbose')) {
        child.stdout.pipe(process.stdout);
      }
      return child.stderr.pipe(process.stderr);
    };
    return grunt.registerMultiTask('latex', 'Compile a LaTeX source file to PDF', function(){
      var done, args;
      done = this.async();
      args = ['lualatex', '--interaction=nonstopmode', '--halt-on-error'];
      grunt.log.writeln("Creating pdfs with " + args[0] + ":");
      return async.forEachSeries(this.filesSrc, function(f, cb){
        var tmpArgs;
        tmpArgs = args.slice(0);
        tmpArgs.push(f);
        return compile(tmpArgs, cb);
      }, done);
    });
  };
}).call(this);
