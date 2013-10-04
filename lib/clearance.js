(function(){
  "use strict";
  module.exports = function(grunt){
    return grunt.registerTask("clearance", "set or get the clearance level", function(target){
      var clearanceFile, old;
      clearanceFile = ".clearance";
      old = grunt.file.exists(clearanceFile) ? grunt.file.read(clearanceFile) : void 8;
      if (target == null) {
        target = grunt.file.exists(clearanceFile)
          ? grunt.file.read(clearanceFile)
          : -1;
      }
      target = ~~target;
      grunt.log.ok("Clearance level " + target);
      grunt.file.write(clearanceFile, "" + target);
      grunt.config.set("clearanceLevel", +target);
      grunt.clearanceLevel = target;
      grunt.config.set("yeoman.sources", target < 0
        ? grunt.config.get("yeoman.samples")
        : grunt.config.get("yeoman.content"));
      grunt.log.ok("Content directory is " + grunt.config.get("yeoman.sources"));
      if (target !== +old) {
        grunt.log.writeln('\n' + '* * * * * * * * * * * * * * * * * * * * * * * * * ');
        grunt.log.writeln('* * * Level changed!  Now run `grunt clean` * * *');
        return grunt.log.writeln('* * * * * * * * * * * * * * * * * * * * * * * * * ');
      }
    });
  };
}).call(this);
