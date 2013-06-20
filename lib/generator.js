(function(){
  "use strict";
  var jsy;
  jsy = require('js-yaml');
  module.exports = function(grunt, metadata){
    var resourceLayout, _, sources, stationsByLine, folder, items, resources, resourceName, files, index, fileName, meta;
    _ = grunt.util._;
    grunt.log.debug("RUNNING GENERATOR");
    metadata = expandMetadata(metadata);
    sources = metadata.sources;
    stationsByLine = _.groupBy(sources.stations, function(station, stationId){
      return stationId.split(/\d/)[0];
    });
    for (folder in sources) {
      items = sources[folder];
      if (folder === 'resources') {
        resources = items;
        for (resourceName in resources) {
          files = resources[resourceName];
          index = files.index;
          fileName = 'index';
          meta = index.meta;
          generateResource(sources, folder, resourceName, fileName, meta);
        }
      } else {
        for (fileName in items) {
          meta = items[fileName];
          if (fileName === 'meta') {
            generateHTML(sources, null, folder, meta);
          } else {
            generateHTML(sources, folder, fileName, meta.meta);
          }
        }
      }
    }
    return metadata;
    function getLayout(sources, folder, meta){
      var prefix, postfix, layout, m, ref$;
      prefix = 'sources/layouts/';
      postfix = '.html';
      layout = meta.layout;
      if (!layout) {
        layout = !folder
          ? 'home'
          : (m = folder.match(/(^.+)s$/), (ref$ = m != null ? m[1] : void 8) != null ? ref$ : folder);
      }
      layout = prefix + layout + postfix;
      if (grunt.file.exists(layout)) {
        return layout;
      } else {
        return prefix + 'default' + postfix;
      }
    }
    function generateResource(sources, folder, resourceName, fileName, meta){
      var layout, _head, _nav, _foot, common, content, html;
      layout = getLayout(sources, folder, meta);
      if (resourceLayout == null) {
        _head = grunt.file.read("sources/layouts/_head.html");
        _nav = grunt.file.read("sources/layouts/_nav.html");
        _foot = grunt.file.read("sources/layouts/_foot.html");
        common = grunt.template.process(grunt.file.read(layout), {
          data: {
            _head: _head,
            _nav: _nav,
            _foot: _foot,
            content: '<%= content %>',
            root: '../..',
            resources: '..'
          }
        });
        resourceLayout = _.template(common);
      }
      content = grunt.file.read("partials/resources/" + resourceName + "/index.html");
      html = resourceLayout({
        content: content
      });
      return grunt.file.write("app/" + folder + "/" + resourceName + "/index.html", html);
    }
    function generateHTML(sources, folder, fileName, meta){
      var layout, _head, _nav, _foot, _linesMenu, content, root, resources, html;
      layout = getLayout(sources, folder, meta);
      _head = grunt.file.read("sources/layouts/_head.html");
      _nav = grunt.file.read("sources/layouts/_nav.html");
      _foot = grunt.file.read("sources/layouts/_foot.html");
      _linesMenu = grunt.file.read("sources/layouts/_linesMenu.html");
      if (folder && folder.length > 0) {
        content = grunt.file.read("partials/" + folder + "/" + fileName + ".html");
        root = "..";
        resources = '../resources';
      } else {
        content = grunt.file.read("partials/" + fileName + ".html");
        root = ".";
        resources = './resources';
      }
      html = grunt.template.process(grunt.file.read(layout), {
        data: {
          _head: _head,
          _nav: _nav,
          _foot: _foot,
          _linesMenu: _linesMenu,
          meta: meta,
          stationsByLine: stationsByLine,
          content: content,
          sources: sources,
          root: root,
          resources: resources
        }
      });
      if (folder) {
        return grunt.file.write("app/" + folder + "/" + fileName + ".html", html);
      } else {
        return grunt.file.write("app/" + fileName + ".html", html);
      }
    }
    function expandMetadata(metadata){
      var sources, stations, pervasiveIdeas, resources;
      sources = metadata.sources;
      stations = sources.stations;
      pervasiveIdeas = sources.pervasiveIdeas;
      resources = sources.resources;
      _.each(resources, function(resource, resourceId){
        var meta;
        meta = resource.index.meta;
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
        _.each(meta.pvids1, function(id){
          var pv;
          pv = pervasiveIdeas[id].meta;
          pv.R1s == null && (pv.R1s = {});
          return pv.R1s[resourceId] = meta.resourceType;
        });
        return _.each(meta.pvids2, function(id){
          var pv;
          pv = pervasiveIdeas[id].meta;
          pv.R2s == null && (pv.R2s = {});
          return pv.R2s[resourceId] = meta.resourceType;
        });
      });
      _.each(stations, function(station, id){
        var dependencies, ref$, stpvs, R1s;
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
        return _.each(R1s, function(resourceType, resourceId){
          var pvids1;
          pvids1 = sources.resources[resourceId].index.meta.pvids1;
          return _.each(pvids1, function(pvid){
            return stpvs[pvid] = true;
          });
        });
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
      return metadata;
    }
    return expandMetadata;
  };
}).call(this);
