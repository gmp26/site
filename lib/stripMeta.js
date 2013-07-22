(function(){
  "use strict";
  var async, pathUtils, jsy, metaStore;
  async = require('async');
  pathUtils = require('path');
  jsy = require('js-yaml');
  metaStore = require('../lib/metaStore.js');
  module.exports = function(grunt){
    var lf, lflf, yamlre, task;
    lf = grunt.util.linefeed;
    lflf = lf + lf;
    yamlre = /^````$\n^([^`]*)````/m;
    task = function(){};
    return grunt.registerMultiTask("stripMeta", "Extract yaml from yaml+content files", function(){
      var store, partialsDir, isolateToken, isolateRe, isolate, writeYAML, options, appendStation, appendPervasiveIdea, readResources;
      store = metaStore(grunt);
      partialsDir = grunt.config.get("yeoman.partials");
      isolateToken = grunt.file.read(".isolate");
      if (!(isolateToken.length > 0 && isolateToken !== ".*")) {
        isolateRe = new RegExp(isolateToken);
      } else {
        isolateRe = null;
      }
      isolate = function(meta){
        var i$, ref$, len$, stid, pvid;
        if (meta.resourceType.matches(isolateRe)) {
          return true;
        }
        for (i$ = 0, len$ = (ref$ = meta.stids1).length; i$ < len$; ++i$) {
          stid = ref$[i$];
          if (stid.matches(isolateRe)) {
            return true;
          }
        }
        for (i$ = 0, len$ = (ref$ = meta.pvids1).length; i$ < len$; ++i$) {
          pvid = ref$[i$];
          if (pvid.matches(isolateRe)) {
            return true;
          }
        }
        return false;
      };
      writeYAML = function(){
        var metadata;
        metadata = jsy.safeDump(store.root);
        if (_.isString(options.metaDataObj)) {
          grunt[options.metaDataObj] = metadata;
        }
        if (_.isString(options.metaDataPath)) {
          return grunt.file.write(options.metaDataPath, metadata);
        }
      };
      options = this.options({
        metaDataPath: partialsDir + "/sources.yaml",
        metaDataObj: "metadata",
        stripMeta: '````',
        spawnLimit: 1
      });
      appendStation = function(stpath, stid){
        var src, yaml, p, basename, dirname, pathname, data, deps, i$, len$, depid, depPath, results$ = [];
        grunt.log.write("  " + append + " station " + stid);
        src = grunt.file.read(stpath);
        yaml = src.match(yamlre) ? matches[1] : "";
        if (yaml.length > 0) {
          p = pathUtils.normalize(stpath);
          basename = pathUtils.basename(p, '.md');
          dirname = pathUtils.dirname(p);
          pathname = dirname + "/" + basename;
          data = {
            meta: jsy.safeLoad(yaml)
          };
          store.setPathData(pathname, data);
          deps = data.meta.dependencies;
          if (_.isArray(deps) && deps.length > 0) {
            for (i$ = 0, len$ = deps.length; i$ < len$; ++i$) {
              depid = deps[i$];
              depPath = sourceDir + "/stations/" + depid + ".md";
              if (store.root.sources.stations[depid] == null && grunt.file.exists(depPath)) {
                results$.push(appendStation(depPath, depid));
              }
            }
            return results$;
          }
        }
      };
      appendPervasiveIdea = function(pvpath, pvid){
        var src, yaml, p, basename, dirname, pathname, data;
        grunt.log.write("  " + append + " pervasiveIdea " + pvid);
        src = grunt.file.read(pvpath);
        yaml = src.match(yamlre) ? matches[1] : "";
        if (yaml.length > 0) {
          p = pathUtils.normalize(pvpath);
          basename = pathUtils.basename(p, '.md');
          dirname = pathUtils.dirname(p);
          pathname = dirname + "/" + basename;
          data = {
            meta: jsy.safeLoad(yaml)
          };
          return store.setPathData(pathname, data);
        }
      };
      return readResources = function(){
        var i$, ref$, len$, f, fpaths, results$ = [];
        for (i$ = 0, len$ = (ref$ = this.files).length; i$ < len$; ++i$) {
          f = ref$[i$];
          results$.push(fpaths = f.src.filter(fn$));
        }
        return results$;
        function fn$(path){
          var src, yaml, p, basename, dirname, pathname, data, e, i$, ref$, len$, stid, stpath, pvid, pvpath, results$ = [];
          if (!grunt.file.exists(path)) {
            grunt.verbose.warn("Input file \"" + path + "\" not found.");
            return false;
          } else {
            grunt.log.write(path + "");
            src = grunt.file.read(path);
            yaml = src.match(yamlre) ? matches[1] : "";
            if (yaml.length > 0) {
              p = pathUtils.normalize(path);
              basename = pathUtils.basename(p, '.md');
              dirname = pathUtils.dirname(p);
              pathname = dirname + "/" + basename;
              try {
                data = {
                  meta: jsy.safeLoad(yaml)
                };
              } catch (e$) {
                e = e$;
                grunt.log.error(e + " parsing metadata in " + pathname);
                return false;
              }
              store.setPathData(pathname, data);
              if (dirname === "resources" || dirname === "examQuestions") {
                if (grunt.clearance > data.meta.clearance) {
                  grunt.log.error("excluding " + path + ":" + data.meta.clearance);
                  return false;
                }
                if (!isolate(data.meta)) {
                  return false;
                }
              }
              for (i$ = 0, len$ = (ref$ = data.meta.stids1.concat(data.meta.stids2)).length; i$ < len$; ++i$) {
                stid = ref$[i$];
                stpath = sourceDir + "/stations/" + stid + ".md";
                if (store.root.sources.stations[stid] == null && grunt.file.exists(stpath)) {
                  appendStation(stpath, stid);
                }
              }
              for (i$ = 0, len$ = (ref$ = data.meta.pvids1.concat(data.meta.pvids2)).length; i$ < len$; ++i$) {
                pvid = ref$[i$];
                pvpath = sourceDir + "/pervasiveIdeas/" + pvid + ".md";
                if (store.root.sources.pervasiveIdeas[pvid] == null && grunt.file.exists(pvpath)) {
                  results$.push(appendPervasiveIdea(pvpath, pvid));
                }
              }
              return results$;
            }
          }
        }
      };
    });
  };
}).call(this);
