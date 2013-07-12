(function(){
  "use strict";
  module.exports = function(grunt){
    var getLayout, _;
    getLayout = require('./getLayout.js')(grunt);
    _ = grunt.util._;
    return grunt.registerTask("generator", "Generate the site html, javascripts and CSS.", function(){
      var metadata, sources, sourcesDir, partialsDir, appDir, _head, _nav, _foot, getResourceData, lastFolder, folder, items, resources, resourceName, files, indexMeta, layout, content, html, fileName, meta;
      grunt.verbose.writeln("Generating site");
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      sourcesDir = grunt.config.get("yeoman.sources");
      partialsDir = grunt.config.get("yeoman.partials");
      appDir = grunt.config.get("yeoman.app");
      _head = grunt.file.read("layouts/_head.html");
      _nav = grunt.file.read("layouts/_nav.html");
      _foot = grunt.file.read("layouts/_foot.html");
      getResourceData = require('./getResourceData.js')(grunt, sources, partialsDir, _head, _nav, _foot);
      lastFolder = null;
      for (folder in sources) {
        items = sources[folder];
        if (folder !== lastFolder) {
          grunt.log.writeln("Generating " + folder);
          lastFolder = folder;
        }
        if (folder === 'resources') {
          resources = items;
          for (resourceName in resources) {
            files = resources[resourceName];
            indexMeta = files.index.meta;
            layout = getLayout(sources, folder, indexMeta);
            content = getResourceData(layout, resourceName, files, indexMeta);
            html = grunt.template.process(grunt.file.read(layout), {
              data: {
                _head: _head,
                _nav: _nav,
                _foot: _foot,
                resourceTypeMeta: sources.resourceTypes[indexMeta.resourceType].meta,
                content: content,
                meta: indexMeta,
                root: '../..',
                resources: '..'
              }
            });
            grunt.file.write("app/" + folder + "/" + resourceName + "/index.html", html);
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
      generateLess(sources);
      return metadata;
      function generateHTML(sources, folder, fileName, meta){
        var layout, _head, _nav, _foot, _linesMenu, content, root, resources, html;
        layout = getLayout(sources, folder, meta);
        _head = grunt.file.read("layouts/_head.html");
        _nav = grunt.file.read("layouts/_nav.html");
        _foot = grunt.file.read("layouts/_foot.html");
        _linesMenu = grunt.file.read("layouts/_linesMenu.html");
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
            content: content,
            sources: sources,
            root: root,
            resources: resources
          }
        });
        if (folder) {
          return grunt.file.write(appDir + "/" + folder + "/" + fileName + ".html", html);
        } else {
          return grunt.file.write(appDir + "/" + fileName + ".html", html);
        }
      }
      function generateLess(sources){
        var css;
        css = '';
        _.each(sources.lines, function(line, lineId){
          var colour;
          colour = line.meta.colour;
          return css += "@linecolor" + lineId + ": " + colour + ";\n";
        });
        grunt.file.write(appDir + "/styles/lineVars.less", css);
        css = '';
        _.each(sources.lines, function(line, lineId){
          return css += ".button" + lineId + " {\n  .button-line(@linecolor" + lineId + ")\n}\n";
        });
        return grunt.file.write(appDir + "/styles/lines.less", css);
      }
      return generateLess;
    });
  };
}).call(this);
