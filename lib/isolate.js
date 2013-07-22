(function(){
  "use strict";
  module.exports = function(grunt){
    return grunt.registerTask("isolate", "set or get the isolate token", function(token){
      var isolateFile;
      isolateFile = ".isolate";
      if (token == null) {
        token = grunt.file.exists(isolateFile) ? grunt.file.read(isolateFile) : ".*";
      }
      grunt.log.ok("Isolate token " + token);
      return grunt.file.write(isolateFile, "" + token);
    });
  };
}).call(this);
