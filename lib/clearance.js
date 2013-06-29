(function(){
  "use strict";
  module.exports = function(grunt){
    return grunt.registerTask("clearance", "set or get the clearance level", function(target){
      var clearanceFile;
      clearanceFile = ".clearance";
      if (target == null) {
        target = grunt.file.exists(clearanceFile)
          ? grunt.file.read(clearanceFile)
          : -1;
      }
      target = ~~target;
      grunt.log.ok("Clearance level " + target);
      grunt.file.write(clearanceFile, "" + target);
      grunt.config.set("yeoman.sources", target < 0
        ? grunt.config.get("yeoman.samples")
        : grunt.config.get("yeoman.content"));
      return grunt.log.ok("Content directory is " + grunt.config.get("yeoman.sources"));
    });
  };
}).call(this);
