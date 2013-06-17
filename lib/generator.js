(function(){
  "use strict";
  var jsy;
  jsy = require('js-yaml');
  module.exports = function(grunt){
    var resourceLayout, _, addStationDependents;
    _ = grunt.util._;
    addStationDependents = function(metadata){
      var stations;
      stations = metadata.sources.stations;
      _.each(stations, function(station, id){
        var dependencies;
        dependencies = station.meta.dependencies;
        return _.each(dependencies, function(dependencyId){
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
              grunt.log.debug("adding dependent " + id + " to " + dependencyId);
              return dependents.push(id);
            }
          }
        });
      });
      return metadata;
    };
    return function(metadata){
      var sources, stationsByLine, getLayout, generateResource, generateHTML, folder, items, resources, resourceName, files, index, fileName, meta;
      grunt.log.debug("RUNNING");
      sources = addStationDependents(metadata).sources;
      stationsByLine = _.groupBy(sources.stations, function(station, stationId){
        return stationId.split(/\d/)[0];
      });
      getLayout = function(sources, folder, meta){
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
      };
      generateResource = function(sources, folder, resourceName, fileName, meta){
        var layout, _head, _nav, _foot, common, content, html;
        layout = getLayout(sources, folder, meta);
        grunt.log.debug("  layout = " + layout);
        if (resourceLayout == null) {
          grunt.log.debug("Compiling resource layout");
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
      };
      generateHTML = function(sources, folder, fileName, meta){
        var layout, _head, _nav, _foot, _linesMenu, content, root, resources, html;
        layout = getLayout(sources, folder, meta);
        grunt.log.debug("folder=" + folder + " file=" + fileName + " layout = " + layout);
        _.each(meta, function(value, key){
          return grunt.log.debug("meta.key=" + key);
        });
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
            resources: resources,
            primaryResources: function(stid){
              return ['G2_RT2', 'G2_RT3', 'G2_RT7'];
            }
          }
        });
        if (folder) {
          return grunt.file.write("app/" + folder + "/" + fileName + ".html", html);
        } else {
          return grunt.file.write("app/" + fileName + ".html", html);
        }
      };
      for (folder in sources) {
        items = sources[folder];
        grunt.log.debug("folder = <" + folder + ">");
        if (folder === 'resources') {
          resources = items;
          for (resourceName in resources) {
            files = resources[resourceName];
            grunt.log.debug("  resource = <" + resourceName + ">");
            index = files.index;
            fileName = 'index';
            meta = index.meta;
            generateResource(sources, folder, resourceName, fileName, meta);
          }
        } else {
          for (fileName in items) {
            meta = items[fileName];
            grunt.log.debug("  file = <" + fileName + ">");
            if (fileName === 'meta') {
              generateHTML(sources, null, folder, meta);
            } else {
              generateHTML(sources, folder, fileName, meta.meta);
            }
          }
        }
      }
      return 0;
    };
  };
}).call(this);
