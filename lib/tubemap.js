(function(){
  "use strict";
  var jsy;
  jsy = require('js-yaml');
  module.exports = function(grunt){
    var _;
    _ = grunt.util._;
    return grunt.registerMultiTask("tubemap", "Generate the tube map.", function(){
      var done, options;
      done = this.async();
      options = this.options();
      return _.each(this.files, function(f){
        var src, metadata, output, prevlinecolour, i, postreplace, stationname, ref$, data, linename, linecolour, dep, dept, ordered, replacement, next, reg, options;
        src = f.src.filter(function(filepath){
          if (!grunt.file.exists(filepath)) {
            grunt.log.warn("Source file \"" + filepath + "\" not found.");
            return false;
          } else {
            return true;
          }
        });
        metadata = grunt.file.readYAML(src[0]).sources;
        output = '';
        prevlinecolour = '';
        i = 0;
        postreplace = [];
        debugger;
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
        grunt.file.write('test/actual/tubemap.dot', output);
        options = {
          cmd: 'dot',
          args: ['-Tsvg', "-o" + f.dest, 'test/actual/tubemap.dot']
        };
        grunt.util.spawn(options, function(error, result, code){
          grunt.log.debug(code);
          if (code !== 0) {
            grunt.log.error(result.stderr);
          }
          return done();
        });
        return grunt.log.writeln("File \"" + f.dest + "\" created.");
      });
    });
  };
}).call(this);
