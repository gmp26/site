(function(){
  "use strict";
  module.exports = function(grunt){
    return grunt.registerTask("integrate", "remove the isolate file", function(token){
      var isolateFile;
      isolateFile = ".isolate";
      if (grunt.file.exists(isolateFile)) {
        return grunt.file['delete'](isolateFile);
      }
    });
  };
}).call(this);
