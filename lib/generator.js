(function(){
  "use strict";
  module.exports = function(grunt){
    var getLayout, _;
    getLayout = require('./getLayout.js')(grunt);
    _ = grunt.util._;
    return grunt.registerTask("generator", "Generate the site html, javascripts and CSS.", function(){
      var metadata, sources, sourcesDir, partialsDir, appDir, _head, _nav, _foot, _linesMenu, _piMenu, getResourceData, getPervasiveIdeaData, lastFolder, folder, items, meta, layout, families, pervasiveIdeas, content, html, resources, resourceName, files, indexMeta, pvid, data, resourceTypes, stations, fileName;
      grunt.verbose.writeln("Generating site");
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      sourcesDir = grunt.config.get("yeoman.sources");
      partialsDir = grunt.config.get("yeoman.partials");
      appDir = grunt.config.get("yeoman.app");
      _head = grunt.file.read("layouts/_head.html");
      _nav = grunt.file.read("layouts/_nav.html");
      _foot = grunt.file.read("layouts/_foot.html");
      _linesMenu = grunt.file.read("layouts/_linesMenu.html");
      _piMenu = grunt.file.read("layouts/_piMenu.html");
      getResourceData = require('./getResourceData.js')(grunt, sources, partialsDir);
      getPervasiveIdeaData = require('./getPervasiveIdeaData.js')(grunt, sources, partialsDir);
      lastFolder = null;
      for (folder in sources) {
        items = sources[folder];
        if (folder !== lastFolder) {
          grunt.log.writeln("Generating " + folder);
          lastFolder = folder;
        }
        switch (folder) {
        case 'pervasiveIdeasHome':
          meta = items.meta;
          layout = getLayout(sources, folder, meta);
          families = metadata.families;
          pervasiveIdeas = sources.pervasiveIdeas;
          content = grunt.file.read(partialsDir + "/pervasiveIdeasHome.html");
          html = grunt.template.process(grunt.file.read(layout), {
            data: {
              _head: _head,
              _nav: _nav,
              _foot: _foot,
              content: content,
              meta: meta,
              families: families,
              pervasiveIdeas: pervasiveIdeas,
              rootUrl: '.',
              resourcesUrl: './resources'
            }
          });
          grunt.file.write(appDir + "/pervasiveIdeasHome.html", html);
          break;
        case 'resources':
          resources = items;
          for (resourceName in resources) {
            files = resources[resourceName];
            indexMeta = files.index.meta;
            layout = getLayout(sources, folder, indexMeta);
            content = getResourceData(resourceName, files, indexMeta);
            html = grunt.template.process(grunt.file.read(layout), {
              data: {
                _head: _head,
                _nav: _nav,
                _foot: _foot,
                resourceTypeMeta: sources.resourceTypes[indexMeta.resourceType].meta,
                content: content,
                meta: indexMeta,
                rootUrl: '../..',
                resourcesUrl: '..'
              }
            });
            grunt.file.write("app/resources/" + resourceName + "/index.html", html);
          }
          break;
        case 'pervasiveIdeas':
          pervasiveIdeas = items;
          for (pvid in items) {
            data = items[pvid];
            meta = data.meta;
            layout = getLayout(sources, folder, meta);
            resources = sources.resources;
            resourceTypes = sources.resourceTypes;
            stations = sources.stations;
            content = getPervasiveIdeaData(pvid, meta);
            html = grunt.template.process(grunt.file.read(layout), {
              data: {
                _piMenu: _piMenu,
                _head: _head,
                _nav: _nav,
                _foot: _foot,
                meta: meta,
                content: content,
                sources: sources,
                stations: stations,
                resources: resources,
                resourceTypes: resourceTypes,
                families: metadata.families,
                rootUrl: '..',
                resourcesUrl: '../resources'
              }
            });
            grunt.file.write(appDir + "/pervasiveIdeas/" + pvid + ".html", html);
          }
          break;
        default:
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
        var layout, content, root, resources, html;
        layout = getLayout(sources, folder, meta);
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
            rootUrl: root,
            resourcesUrl: resources
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
