(function(){
  "use strict";
  module.exports = function(grunt){
    return grunt.registerTask("isolate", "set or get the isolate token", function(token){
      var isolateFile, csl;
      isolateFile = ".isolate";
      if (token == null) {
        token = grunt.file.exists(isolateFile)
          ? grunt.file.read(isolateFile)
          : grunt.log.ok("Integrated, not isolated");
      }
      if (token != null) {
        if (token.indexOf(',') > 0) {
          csl = token.split(',');
          token = '(' + csl.join(')|(') + ')';
        }
        grunt.log.ok("Isolate token " + token);
        return grunt.file.write(isolateFile, "" + token);
      }
    });
  };
}).call(this);
