(function(){
  "use strict";
  module.exports = function(grunt){
    var metadata, sources, stations, examQuestions;
    metadata = grunt.metadata;
    sources = metadata.sources;
    stations = metadata.stations;
    examQuestions = metadata.examQuestions;
    return function(id){
      var html, i$, ref$, len$, folder;
      html = "";
      for (i$ = 0, len$ = (ref$ = ["stations"]).length; i$ < len$; ++i$) {
        folder = ref$[i$];
        switch (folder) {
        case 'station':
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
