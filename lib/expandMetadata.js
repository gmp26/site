(function(){
  "use strict";
  var jsy, colorString;
  jsy = require('js-yaml');
  colorString = require('color-string');
  module.exports = function(grunt){
    var _;
    _ = grunt.util._;
    return grunt.registerTask("expandMetadata", "Expand metadata for efficiency.", function(){
      var options, partialsDir, sourcesDir, metadata, sources, stations, pervasiveIdeas, resources, resourceTypes, lines, badLines, badPVs, badStations, stationsByLine, badResources;
      grunt.verbose.writeln("Expanding metadata");
      options = this.options({});
      partialsDir = grunt.config.get("yeoman.partials");
      sourcesDir = grunt.config.get("yeoman.sources");
      metadata = grunt.config.get("metadata");
      metadata = grunt.file.readYAML(partialsDir + "/sources.yaml");
      grunt.config.set("metadata", metadata);
      sources = metadata.sources;
      stations = sources.stations;
      pervasiveIdeas = sources.pervasiveIdeas;
      resources = sources.resources;
      resourceTypes = sources.resourceTypes;
      lines = sources.lines;
      badLines = {};
      _.each(sources.lines, function(line, lid){
        var meta, rgba;
        meta = line.meta;
        if (!(_.isString(lid) && lid.match(/^\D{1,3}$/))) {
          grunt.log.error("Line " + lid + " has a bad name");
          badLines[lid] = true;
        }
        if (meta.id !== lid) {
          grunt.log.error("Line " + lid + " has an invalid id " + meta.id + ". Using '" + lid + "'.");
        }
        meta.id = lid;
        try {
          rgba = colorString.getRgba(meta.colour);
        } catch (e$) {}
        if (!rgba) {
          grunt.log.error("Line " + lid + " has an invalid colour " + meta.colour + ". Using grey");
          return meta.colour = '#CCCCCC';
        }
      });
      _.each(badLines, function(b, badLineId){
        delete sources.lines[badLineId];
        return grunt.log.error("*** Ignoring line " + badLineId);
      });
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
          grunt.log.error("PervasiveIdea " + pvid + " has incorrect id '" + meta.id + "' in metadata");
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
        var meta, m;
        meta = st.meta;
        if (meta.title == null || meta.title === null || meta.title === "") {
          badStations[stid] = true;
          grunt.log.error("Station " + stid + " has no title");
        }
        if (meta.id != null && meta.id !== stid) {
          grunt.log.error("Overriding '" + meta.id + "' with " + stid + " in station '" + stid + "'");
        }
        meta.id = stid;
        m = stid.match(/^(\D{1,3})(\d{1,2})([a-z])?$/);
        if (m) {
          meta.line = m[1];
          if (sources.lines[meta.line] != null) {
            meta.rank = +(m[2] + (m[3] ? ((m[3].charCodeAt(0) - 'a'.charCodeAt(0) + 1) / 100).toFixed(2).substr(1) : ''));
            return meta.colour = sources.lines[meta.line].meta.colour;
          } else {
            badStations[stid] = true;
            return grunt.log.error("Station " + stid + " is on a missing line " + meta.line);
          }
        } else {
          grunt.log.error("Station " + stid + " has an invalid id - should be in Xn to XXXnnx");
          if (!m) {
            return badStations[stid] = true;
          }
        }
      });
      _.each(badStations, function(b, badId){
        var ref$;
        grunt.log.warn("*** Ignoring station " + badId);
        return ref$ = stations[badId], delete stations[badId], ref$;
      });
      stationsByLine = _.groupBy(stations, function(it){
        return it.meta.line;
      });
      _.each(_.keys(stationsByLine), function(lid){
        stationsByLine[lid] = _.sortBy(stationsByLine[lid], function(it){
          return it.meta.rank;
        });
        return lines[lid].meta.stids = _.map(stationsByLine[lid], function(obj){
          return obj.meta.id;
        });
      });
      badResources = {};
      _.each(resources, function(resource, resourceId){
        var meta, expandIds;
        if (resource.index == null) {
          grunt.log.error(resourceId + " should be a folder with an index file");
          badResources[resourceId] = true;
          return;
        }
        meta = resource.index.meta;
        meta.id = resourceId;
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
        expandIds = function(objList, idPrefix, idNumber){
          var bad, srcList;
          bad = {};
          srcList = meta[idPrefix + idNumber];
          _.each(srcList, function(id, index){
            var highlight, obj, objMeta, resListId, oml, res;
            grunt.log.ok("testing id " + id);
            highlight = idNumber === 1 && id.match(/\s*(\w+)\*/);
            if (highlight) {
              debugger;
              grunt.log.ok("highlight");
              id = highlight[1];
              srcList[index] = id;
            }
            obj = objList[id];
            if (obj && obj.meta != null) {
              objMeta = obj.meta;
              resListId = "R" + idNumber + "s";
              objMeta[resListId] == null && (objMeta[resListId] = []);
              oml = objMeta[resListId];
              res = {
                id: resourceId,
                rt: meta.resourceType,
                highlight: highlight !== null
              };
              if (meta.title) {
                res.title = meta.title;
                grunt.log.ok("***** writing " + meta.title + " to res *****");
              }
              oml.push(res);
              return objMeta[resListId] = _.sortBy(oml, function(obj){
                return +obj.rt.substr(2);
              });
            } else {
              return bad[id] = true;
            }
          });
          if (srcList) {
            return meta[idPrefix + idNumber] = _.sortBy(_.filter(srcList, function(id){
              if (bad[id]) {
                grunt.log.error(resourceId + " " + idPrefix + idNumber + " refers to missing " + id);
                return false;
              } else {
                return true;
              }
            }));
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
        var dependencies, ref$, stpvs, R1s;
        dependencies = station.meta.dependencies;
        if (_.isString(dependencies) && stations[dependencies] != null) {
          dependencies = [dependencies];
        }
        if (dependencies && !_.isArray(dependencies)) {
          grunt.fatal(id + " dependencies must be a list");
        }
        _.each(dependencies, function(dependencyId, index){
          var dependency, ref$, depMeta;
          if (dependencyId && _.isString(dependencyId) && dependencyId.length > 0) {
            if (dependencyId === id) {
              grunt.log.error("Station " + id + " is listed in its own dependencies");
              return;
            }
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
              return grunt.log.error("Station " + id + " references a missing dependency " + dependencyId);
            }
          } else {
            grunt.log.error("Station " + id + " has an invalid dependency '" + dependencyId + "', ignoring it");
            return dependencies.splice(index, 1);
          }
        });
        (ref$ = station.meta).pervasiveIdeas == null && (ref$.pervasiveIdeas = {});
        stpvs = station.meta.pervasiveIdeas;
        R1s = station.meta.R1s;
        return _.each(R1s, function(resObj){
          var resIndex, pvids1, pvids2;
          resIndex = sources.resources[resObj.id].index;
          if (resIndex) {
            pvids1 = resIndex.meta.pvids1;
            _.each(pvids1, function(pvid){
              return stpvs[pvid] = true;
            });
            pvids2 = resIndex.meta.pvids2;
            return _.each(pvids2, function(pvid){
              return stpvs[pvid] = true;
            });
          } else {
            return grunt.log.error("Station " + station.meta.id + " has missing R1: " + resObj.id);
          }
        });
      });
      _.each(pervasiveIdeas, function(pervasiveIdea, id){
        var ref$, pvstids, R1s;
        (ref$ = pervasiveIdea.meta).stids == null && (ref$.stids = {});
        pvstids = pervasiveIdea.meta.stids;
        R1s = pervasiveIdea.meta.R1s;
        return _.each(R1s, function(resObj){
          var stids1;
          stids1 = sources.resources[resObj.id].index.meta.stids1;
          return _.each(stids1, function(stid){
            return pvstids[stid] = true;
          });
        });
      });
      return grunt.file.write(partialsDir + "/expanded.yaml", jsy.safeDump(metadata));
    });
  };
}).call(this);
