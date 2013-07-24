(function(){
  "use strict";
  module.exports = function(grunt){
    var _;
    _ = grunt.util._;
    return function(id){
      var metadata, sources, stations, examQuestions, html, i$, ref$, len$, folder;
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      stations = sources.stations;
      examQuestions = sources.examQuestions;
      html = "";
      for (i$ = 0, len$ = (ref$ = ["stations"]).length; i$ < len$; ++i$) {
        folder = ref$[i$];
        switch (folder) {
        case 'stations':
          _.each(examQuestions, fn$);
          break;
        default:
          html = "No questions found";
        }
      }
      return html;
      function fn$(data, qId){
        var meta;
        if (data.index != null) {
          meta = data.index.meta;
          if (meta.stids1.indexOf(id) >= 0) {
            return html += "Insert " + qId + " here";
          } else {
            return html += "Not " + qId;
          }
        }
      }
    };
  };
}).call(this);
