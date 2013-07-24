(function(){
  "use strict";
  module.exports = function(grunt){
    var _;
    _ = grunt.util._;
    return function(id){
      var metadata, sources, stations, examQuestions;
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      stations = sources.stations;
      return examQuestions = sources.examQuestions;
    };
  };
}).call(this);
