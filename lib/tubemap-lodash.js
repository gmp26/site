(function(){
  "use strict";
  var jsy, pathUtils;
  jsy = require('js-yaml');
  pathUtils = require('path');
  module.exports = function(grunt){
    var _;
    _ = grunt.util._;
    return grunt.registerMultiTask("tubemap", "Generate the tube map.", function(){
      var done, partials, gvFile, options;
      done = this.async();
      debugger;
      partials = grunt.config.get("yeoman.partials");
      gvFile = partials + "/tubemap/tubemap.dot";
      options = this.options();
      return _.each(this.files, function(f){
        var src, metadata, stations, output, prevlinecolour, i, postreplace, newStations, removedStids, time, diff, options;
        src = f.src.filter(function(filepath){
          if (!grunt.file.exists(filepath)) {
            grunt.log.warn("Source file \"" + filepath + "\" not found.");
            return false;
          } else {
            return true;
          }
        });
        metadata = grunt.file.readYAML(src[0]).sources;
        stations = metadata.stations;
        output = '';
        prevlinecolour = '';
        i = 0;
        postreplace = [];
        newStations = {};
        removedStids = [];
        time = process.hrtime();
        _.each(stations, function(data, stationname){
          var meta, names, aliases, newname;
          meta = data.meta;
          if (meta.id != null && meta.dependents != null && meta.dependencies != null && (names = _.intersection(meta.dependents, meta.dependencies)).length > 0 && _.indexOf(stationname, removedStids < 0)) {
            aliases = names.concat(stationname);
            newname = aliases.sort().join('-');
            meta.id = newname;
            newStations[newname] = {
              "meta": meta
            };
            removedStids = removedStids.concat(aliases);
            return _.each(aliases, function(alias){
              var aliasMeta;
              aliasMeta = stations[alias].meta;
              meta.dependents = _.union(meta.dependents, aliasMeta.dependents);
              return meta.dependencies = _.union(meta.dependencies, aliasMeta.dependencies);
            });
          }
        });
        metadata.stations = _.extend(metadata.stations, newStations);
        _.each(removedStids, function(stid){
          var ref$, ref1$;
          return ref1$ = (ref$ = metadata.stations)[stid], delete ref$[stid], ref1$;
        });
        _.each(metadata.stations, function(data, stationname){
          var meta;
          meta = data.meta;
          return _.each(meta.dependents, function(deptMeta, dept){
            if (deptMeta !== '') {
              if (meta.colour !== prevlinecolour) {
                output = output + 'edge [style=bold ,color="' + meta.colour + '"]\n';
                prevlinecolour = meta.colour;
              }
              return output = output + stationname + ' -> ' + deptMeta + ' ;\n';
            }
          });
        });
        diff = process.hrtime(time);
        grunt.log.ok('for took %d nanoseconds', diff[0] * 1e9 + diff[1]);
        output = 'digraph CMEP_Tube {node [shape=plaintext ,fillcolor="#EEF2FF", fontsize=16, fontname=arial]' + output + '}';
        grunt.file.write(gvFile, output);
        options = {
          cmd: 'dot',
          args: ['-Tsvg', "-o" + f.dest, gvFile]
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
