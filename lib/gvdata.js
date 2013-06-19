(function(){
  "use strict";
  module.exports = function(grunt){
    return function(metadata){
      var _, output, prevlinecolour, i, postreplace, stationname, ref$, data, linename, linecolour, dep, dept, ordered, replacement, next, reg, options;
      _ = grunt.util._;
      output = '';
      prevlinecolour = '';
      i = 0;
      postreplace = new Array();
      for (stationname in ref$ = metadata.stations) {
        data = ref$[stationname];
        linename = stationname.replace(/[0-9].*/g, '');
        linecolour = metadata.lines[linename].meta.colour;
        for (dep in data.meta.dependencies) {
          for (dept in data.meta.dependents) {
            if (data.meta.dependencies[dep] === data.meta.dependents[dept]) {
              ordered = _.sortBy([stationname, data.meta.dependents[dept]]);
              replacement = '"' + ordered[0] + '-' + ordered[1] + '"';
              postreplace[i++] = {
                "stationname": stationname,
                "replacement": replacement
              };
              stationname = replacement;
              data.meta.dependents[dept] = '';
            }
          }
        }
        for (dept in data.meta.dependents) {
          if (data.meta.dependents[dept] !== '') {
            if (linecolour !== prevlinecolour) {
              output = output + 'edge [style=bold ,color="' + linecolour + '"]\n';
              prevlinecolour = linecolour;
            }
            output = output + stationname + ' -> ' + data.meta.dependents[dept] + ' ;\n';
          }
        }
      }
      for (next in postreplace) {
        reg = new RegExp(postreplace[next].stationname + ' ', 'g');
        output = output.replace(reg, postreplace[next].replacement);
      }
      output = 'digraph G {node [shape=plaintext ,fillcolor="#EEF2FF", fontsize=16, fontname=arial]' + output + '}';
      grunt.file.write('partials/tubemap.dot', output);
      return options = {
        cmd: '/opt/local/bin/dot',
        args: ['-Tsvg', '-opartials/tubemap.svg', 'partials/tubemap.dot']
      };
    };
  };
}).call(this);
