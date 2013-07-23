(function(){
  "use strict";
  var pathUtils, jsy, metaStore;
  pathUtils = require('path');
  jsy = require('js-yaml');
  metaStore = require('../lib/metaStore.js');
  module.exports = function(grunt){
    var yamlre, _;
    yamlre = /^````$\n^([^`]*)````/m;
    _ = grunt.util._;
    return grunt.registerMultiTask("stripMeta", "Extract yaml from yaml+content files", function(){
      var options, isolateFile, store, partialsDir, sourceDir, isolateToken, isolateRe, isolate, writeYAML, appendStation, appendPervasiveIdea, readResources;
      options = this.options({
        metaDataPath: partialsDir + "/sources.yaml",
        metaDataVar: "metadata",
        stripMeta: '````',
        metaReplace: grunt.config.get("yeoman.sources"),
        metaReplacement: "sources"
      });
      isolateFile = ".isolate";
      store = metaStore(grunt, options);
      partialsDir = grunt.config.get("yeoman.partials");
      sourceDir = grunt.config.get("yeoman.sources");
      if (grunt.file.exists(isolateFile)) {
        isolateToken = grunt.file.read(isolateFile);
      }
      if (!(isolateToken.length > 0)) {
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
        if (_.isString(options.metaDataVar)) {
          grunt.config.set(options.metaDataVar, metadata);
        }
        if (_.isString(options.metaDataPath)) {
          return grunt.file.write(options.metaDataPath, metadata);
        }
      };
      appendStation = function(stpath, stid){
        var src, matches, yaml, p, basename, dirname, pathname, data, deps, i$, len$, depid, depPath, sources, results$ = [];
        grunt.log.write("  append station " + stid);
        debugger;
        src = grunt.file.read(stpath);
        matches = src.match(yamlre);
        if (matches !== null) {
          yaml = matches[1];
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
              sources = store.root[options.metaReplacement];
              sources == null && (sources = {});
              sources.stations == null && (sources.stations = {});
              if (sources.stations[depid] == null && grunt.file.exists(depPath)) {
                results$.push(appendStation(depPath, depid));
              }
            }
            return results$;
          }
        }
      };
      appendPervasiveIdea = function(pvpath, pvid){
        var src, matches, yaml, p, basename, dirname, pathname, data;
        grunt.log.write("  append pervasiveIdea " + pvid);
        src = grunt.file.read(pvpath);
        matches = src.match(yamlre);
        if (matches !== null) {
          yaml = matches[1];
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
      readResources = function(files){
        var i$, len$, f, fpaths, results$ = [];
        for (i$ = 0, len$ = files.length; i$ < len$; ++i$) {
          f = files[i$];
          results$.push(fpaths = f.src.filter(fn$));
        }
        return results$;
        function fn$(path){
          var src, matches, yaml, p, basename, dirname, pathname, data, e, i$, ref$, len$, stid, stpath, ref1$, ref2$, pvid, pvpath, results$ = [];
          if (!grunt.file.exists(path)) {
            grunt.verbose.warn("Input file \"" + path + "\" not found.");
            return false;
          } else {
            grunt.log.write(path + "");
            src = grunt.file.read(path);
            matches = src.match(yamlre);
            if (matches !== null) {
              yaml = matches[1];
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
                if (((ref1$ = store.root[options.metaReplacement]) != null ? (ref2$ = ref1$.stations) != null ? ref2$[stid] : void 8 : void 8) == null && grunt.file.exists(stpath)) {
                  appendStation(stpath, stid);
                }
              }
              for (i$ = 0, len$ = (ref$ = data.meta.pvids1.concat(data.meta.pvids2)).length; i$ < len$; ++i$) {
                pvid = ref$[i$];
                pvpath = sourceDir + "/pervasiveIdeas/" + pvid + ".md";
                if (((ref1$ = store.root[options.metaReplacement]) != null ? (ref2$ = ref1$.pervasiveIdeas) != null ? ref2$[pvid] : void 8 : void 8) == null && grunt.file.exists(pvpath)) {
                  results$.push(appendPervasiveIdea(pvpath, pvid));
                }
              }
              return results$;
            }
          }
        }
      };
      readResources(this.files);
      return grunt.file.write(partialsDir + "/stripped.html", jsy.safeDump(store.root));
    });
  };
}).call(this);
