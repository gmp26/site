(function(){
  "use strict";
  module.exports = function(grunt, sources, partialsDir){
    return function(rtid, meta){
      var _;
      _ = grunt.util._;
      return {
        title: meta.title,
        icon: meta.icon,
        html: grunt.file.read(partialsDir + "/resourceTypes/" + rtid + ".html")
      };
    };
  };
}).call(this);
