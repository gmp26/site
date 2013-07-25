(function(){
  "use strict";
  module.exports = function(grunt){
    var getLayout, _;
    getLayout = require('./getLayout.js')(grunt);
    _ = grunt.util._;
    return grunt.registerTask("generator", "Generate the site html, javascripts and CSS.", function(){
      var metadata, sources, sourcesDir, partialsDir, appDir, _head, _nav, _foot, _linesMenu, _piMenu, getResourceData, getPervasiveIdeaData, lastFolder, folder, items, fileName, meta, layout, content, html, families, pervasiveIdeas, resources, resourceName, files, indexMeta, pvid, data, resourceTypes, stations, noop, stid, root;
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
        case 'index':
        case 'map':
          fileName = folder;
          meta = items.meta;
          layout = getLayout(sources, null, meta);
          content = grunt.file.read(partialsDir + "/" + fileName + ".html");
          html = grunt.template.process(grunt.file.read(layout), {
            data: {
              _head: _head,
              _nav: _nav,
              _foot: _foot,
              _linesMenu: _linesMenu,
              meta: meta,
              content: content,
              sources: sources,
              rootUrl: '.',
              resourcesUrl: './resources'
            }
          });
          grunt.file.write(appDir + "/" + fileName + ".html", html);
          break;
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
        case 'examQuestions':
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
        case 'lines':
        case 'resourceTypes':
          noop = true;
          break;
        case 'stations':
          for (stid in items) {
            meta = items[stid];
            meta = meta.meta;
            layout = getLayout(sources, folder, meta);
            content = grunt.file.read(partialsDir + "/" + folder + "/" + stid + ".html");
            root = "..";
            resources = '../resources';
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
            grunt.file.write(appDir + "/stations/" + stid + ".html", html);
          }
          break;
        default:
          grunt.fail.fatal("***** UNKNOWN FOLDER " + folder + " *****");
        }
      }
      generateLess(sources);
      return metadata;
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
