(function(){
  "use strict";
  var jsy;
  jsy = require('js-yaml');
  module.exports = function(grunt){
    var _;
    _ = grunt.util._;
    return grunt.registerTask("expandMetadata", "Expand metadata for efficiency.", function(){
      var options, partialsDir, metadata, sources, stations, pervasiveIdeas, resources;
      grunt.verbose.writeln("Expanding metadata");
      options = this.options({});
      partialsDir = grunt.config.get("yeoman.partials");
      metadata = grunt.file.readYAML(partialsDir + "/sources.yaml");
      grunt.config.set("metadata", metadata);
      sources = metadata.sources;
      stations = sources.stations;
      pervasiveIdeas = sources.pervasiveIdeas;
      resources = sources.resources;
      _.each(resources, function(resource, resourceId){
        var meta, highlights;
        meta = resource.index.meta;
        highlights = [];
        if (meta.highlight != null) {
          if (_.isBoolean(meta.highlight) && meta.highlight) {
            highlights = sources.stations;
          } else {
            if (_.isString(meta.highlight)) {
              highlights = [sources.stations[meta.highlight]];
            } else {
              if (_.isArray(meta.highlight)) {
                highlights = _.map(meta.highlight, function(stid){
                  return stations[stid];
                });
              }
            }
          }
        }
        _.each(highlights, function(station, stid){
          var st;
          st = station.meta;
          st.highlights == null && (st.highlights = {});
          return st.highlights[resourceId] = meta.resourceType;
        });
        grunt.verbose.writeln("1");
        _.each(meta.stids1, function(id){
          var st;
          st = stations[id].meta;
          st.R1s == null && (st.R1s = {});
          return st.R1s[resourceId] = meta.resourceType;
        });
        _.each(meta.stids2, function(id){
          var st;
          st = stations[id].meta;
          st.R2s == null && (st.R2s = {});
          return st.R2s[resourceId] = meta.resourceType;
        });
        grunt.verbose.writeln("2 - resourceId=" + resourceId);
        return _.each(["1", "2"], function(n){
          var bad;
          bad = {};
          _.each(meta["pvids" + n], function(id){
            var pv, key$;
            grunt.verbose.writeln("pvid" + n + " = " + id);
            if (pervasiveIdeas[id] != null) {
              pv = pervasiveIdeas[id].meta;
              pv[key$ = "R" + n + "s"] == null && (pv[key$] = {});
              return pv["R" + n + "s"][resourceId] = meta.resourceType;
            } else {
              grunt.log.error(resourceId + " references a missing pvid" + n + " " + id);
              debugger;
              return bad[id] = true;
            }
          });
          if (meta["pvids" + n]) {
            return resource.index.meta["pvids" + n] = meta["pvids" + n].filter(function(id){
              return bad.id == null;
            });
          }
        });
      });
      _.each(stations, function(station, id){
        var dependencies, ref$, stpvs, R1s, rank, m;
        dependencies = station.meta.dependencies;
        _.each(dependencies, function(dependencyId){
          var dependency, ref$, dependents;
          if (dependencyId) {
            dependency = (ref$ = stations[dependencyId]) != null ? ref$ : null;
            if (!dependency) {
              grunt.fatal("station " + dependencyId + " not found");
            }
            if (!dependency.meta.dependents) {
              dependency.meta.dependents = [];
            }
            dependents = dependency.meta.dependents;
            if (!(dependents.indexOf(id) >= 0)) {
              return dependents.push(id);
            }
          }
        });
        (ref$ = station.meta).pervasiveIdeas == null && (ref$.pervasiveIdeas = {});
        stpvs = station.meta.pervasiveIdeas;
        R1s = station.meta.R1s;
        _.each(R1s, function(resourceType, resourceId){
          var pvids1, pvids2;
          pvids1 = sources.resources[resourceId].index.meta.pvids1;
          _.each(pvids1, function(pvid){
            return stpvs[pvid] = true;
          });
          pvids2 = sources.resources[resourceId].index.meta.pvids2;
          return _.each(pvids2, function(pvid){
            return stpvs[pvid] = true;
          });
        });
        station.meta.line = id.split(/\d+/)[0];
        rank = id.substr(station.meta.line.length);
        m = rank.match(/^(.*)([a-z])$/);
        if (m) {
          rank = m[1] + ((m[2].charCodeAt(0) - 'a'.charCodeAt(0) + 1) / 100).toFixed(2).substr(1);
        }
        station.meta.rank = +rank;
        return station.meta.colour = sources.lines[station.meta.line].meta.colour;
      });
      _.each(pervasiveIdeas, function(pervasiveIdea, id){
        var ref$, pvstids, R1s;
        (ref$ = pervasiveIdea.meta).stids == null && (ref$.stids = {});
        pvstids = pervasiveIdea.meta.stids;
        R1s = pervasiveIdea.meta.R1s;
        return _.each(R1s, function(resourceType, resourceId){
          var stids1;
          stids1 = sources.resources[resourceId].index.meta.stids1;
          return _.each(stids1, function(stid){
            return pvstids[stid] = true;
          });
        });
      });
      return grunt.file.write(partialsDir + "/expanded.yaml", jsy.safeDump(metadata));
    });
  };
}).call(this);
