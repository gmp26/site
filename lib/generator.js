(function(){
  "use strict";
  var jsy, expandMetadata;
  jsy = require('js-yaml');
  expandMetadata = require('./expandMetadata.js');
  module.exports = function(grunt, metadata){
    var resourceLayout, _, sources, sourcesDir, partialsDir, stationsByLine, folder, items, resources, resourceName, files, index, fileName, meta;
    _ = grunt.util._;
    grunt.verbose.writeln("Generating site");
    metadata = expandMetadata(grunt, metadata);
    sources = metadata.sources;
    sourcesDir = grunt.config.get("yeoman.sources");
    partialsDir = grunt.config.get("yeoman.partials");
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
    grunt.file.write(partialsDir + "/expanded.yaml", jsy.safeDump(metadata));
    return metadata;
    function getLayout(sources, folder, meta){
      var prefix, postfix, layout, m, ref$;
      prefix = grunt.config.get('yeoman.sources') + '/layouts/';
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
      var layout, _head, _nav, _foot, html;
      layout = getLayout(sources, folder, meta);
      _head = grunt.file.read(sourcesDir + "/layouts/_head.html");
      _nav = grunt.file.read(sourcesDir + "/layouts/_nav.html");
      _foot = grunt.file.read(sourcesDir + "/layouts/_foot.html");
      html = grunt.template.process(grunt.file.read(layout), {
        data: {
          _head: _head,
          _nav: _nav,
          _foot: _foot,
          resourceTypeTitle: sources.resourceTypes[meta.resourceType].meta.title,
          content: grunt.file.read(partialsDir + "/resources/" + resourceName + "/index.html"),
          root: '../..',
          resources: '..'
        }
      });
      return grunt.file.write("app/" + folder + "/" + resourceName + "/index.html", html);
    }
    function generateHTML(sources, folder, fileName, meta){
      var layout, _head, _nav, _foot, _linesMenu, content, root, resources, html;
      layout = getLayout(sources, folder, meta);
      _head = grunt.file.read(sourcesDir + "/layouts/_head.html");
      _nav = grunt.file.read(sourcesDir + "/layouts/_nav.html");
      _foot = grunt.file.read(sourcesDir + "/layouts/_foot.html");
      _linesMenu = grunt.file.read(sourcesDir + "/layouts/_linesMenu.html");
      if (folder && folder.length > 0) {
        content = grunt.file.read(partialsDir + "/" + folder + "/" + fileName + ".html");
        root = "..";
        resources = '../resources';
      } else {
        content = grunt.file.read(partialsDir + "/" + fileName + ".html");
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
    return generateHTML;
  };
}).call(this);
