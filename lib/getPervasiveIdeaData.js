(function(){
  "use strict";
  module.exports = function(grunt, sources, partialsDir){
    return function(pvid, meta){
      var _;
      _ = grunt.util._;
      return {
        title: meta.title,
        family: meta.family,
        html: grunt.file.read(partialsDir + "/pervasiveIdeas/" + pvid + ".html")
      };
    };
  };
}).call(this);
