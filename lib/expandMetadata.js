(function(){
  "use strict";
  var jsy;
  jsy = require('js-yaml');
  module.exports = function(grunt){
    var _;
    _ = grunt.util._;
    return grunt.registerTask("expandMetadata", "Expand metadata for efficiency.", function(){
      var options, partialsDir, sourcesDir, metadata, sources, stations, pervasiveIdeas, resources, resourceTypes, badPVs, badStations, badResources;
      grunt.verbose.writeln("Expanding metadata");
      options = this.options({});
      partialsDir = grunt.config.get("yeoman.partials");
      sourcesDir = grunt.config.get("yeoman.sources");
      metadata = grunt.config.get("metadata");
      if (!metadata) {
        metadata = grunt.file.readYAML(partialsDir + "/sources.yaml");
      }
      grunt.config.set("metadata", metadata);
      sources = metadata.sources;
      stations = sources.stations;
      pervasiveIdeas = sources.pervasiveIdeas;
      resources = sources.resources;
      resourceTypes = sources.resourceTypes;
      badPVs = {};
      _.each(pervasiveIdeas, function(pv, pvid){
        var meta;
        meta = pv.meta;
        if (meta.title == null || meta.title === null || meta.title === "") {
          badPVs[pvid] = true;
        }
        if (meta.family == null || meta.family === null || meta.family === "") {
          grunt.log.error("pervasiveIdea " + pvid + " has no family");
        }
        if (meta.id != null && meta.id !== pvid) {
          grunt.log.error("*** Warning: incorrect id '" + meta.id + "' in " + pvid + ", using '" + pvid + "'");
          return meta.id = pvid;
        }
      });
      _.each(badPVs, function(b, badId){
        var ref$;
        grunt.log.warn("*** Ignoring pervasiveIdea " + badId);
        return ref$ = pervasiveIdeas[badId], delete pervasiveIdeas[badId], ref$;
      });
      badStations = {};
      _.each(stations, function(st, stid){
        var meta;
        meta = st.meta;
        if (meta.title == null || meta.title === null || meta.title === "") {
          badPVs[pvid] = true;
        }
        if (meta.id != null && meta.id !== stid) {
          grunt.log.error("*** Warning: incorrect id '" + meta.id + "' in " + stid + ", using '" + stid + "'");
          return meta.id = stid;
        }
      });
      _.each(badStations, function(b, badId){
        var ref$;
        grunt.log.warn("*** Ignoring station " + badId);
        return ref$ = stations[badId], delete stations[badId], ref$;
      });
      badResources = {};
      _.each(resources, function(resource, resourceId){
        var meta, highlights, expandIds;
        if (resource.index == null) {
          grunt.log.error(resourceId + " should be a folder with an index file");
          badResources[resourceId] = true;
          return;
        }
        meta = resource.index.meta;
        if (resource.index.meta == null) {
          grunt.log.error().error(resourceId + " has no metadata");
          badResources[resourceId] = true;
          return;
        }
        if (meta.resourceType == null || !resourceTypes[meta.resourceType]) {
          grunt.log.error(resourceId + " has missing or bad resourceType");
          badResources[resourceId] = true;
          return;
        }
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
        expandIds = function(objList, idPrefix, idNumber){
          var bad, srcList;
          bad = {};
          srcList = meta[idPrefix + idNumber];
          _.each(srcList, function(id){
            var item, itemMeta, resListId;
            item = objList[id];
            if (item && item.meta != null) {
              itemMeta = item.meta;
              resListId = "R" + idNumber + "s";
              itemMeta[resListId] == null && (itemMeta[resListId] = {});
              return itemMeta[resListId][resourceId] = meta.resourceType;
            } else {
              return bad[id] = true;
            }
          });
          if (srcList) {
            return meta[idPrefix + idNumber] = srcList.filter(function(id){
              if (bad[id]) {
                grunt.log.error(resourceId + " " + idPrefix + idNumber + " refers to missing " + id);
                return false;
              } else {
                return true;
              }
            });
          }
        };
        expandIds(stations, "stids", 1);
        expandIds(stations, "stids", 2);
        expandIds(pervasiveIdeas, "pvids", 1);
        return expandIds(pervasiveIdeas, "pvids", 2);
      });
      _.each(badResources, function(b, badId){
        var ref$;
        grunt.log.warn("*** Ignoring resource " + badId);
        return ref$ = resources[badId], delete resources[badId], ref$;
      });
      _.each(stations, function(station, id){
        var dependencies, ref$, stpvs, R1s, rank, m;
        dependencies = station.meta.dependencies;
        if (_.isString(dependencies) && stations[dependencies] != null) {
          dependencies = [dependencies];
        }
        if (dependencies && !_.isArray(dependencies)) {
          grunt.fatal(id + " dependencies must be a list");
        }
        _.each(dependencies, function(dependencyId){
          var dependency, ref$, depMeta;
          if (dependencyId) {
            dependency = (ref$ = stations[dependencyId]) != null ? ref$ : null;
            if (dependency) {
              depMeta = dependency.meta;
              if (!depMeta.dependents) {
                depMeta.dependents = [];
              }
              if (depMeta.dependents.indexOf(id) < 0) {
                return depMeta.dependents.push(id);
              }
            } else {
              return grunt.log.error("*** Ignoring missing station " + id + " reference to missing " + dependencyId);
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
