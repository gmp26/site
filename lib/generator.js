(function(){
  "use strict";
  module.exports = function(grunt){
    var getLayout, _;
    getLayout = require('./getLayout.js')(grunt);
    _ = grunt.util._;
    return grunt.registerTask("generator", "Generate the site html, javascripts and CSS.", function(){
      var metadata, sources, families, pervasiveIdeas, pervasiveIdeasHome, resources, resourceTypes, stations, sourcesDir, partialsDir, appDir, _head, _nav, _foot, _linesMenu, _piMenu, getResourceData, getPervasiveIdeaData, meta, layout, html, content, pvid, data, resourceName, files, indexMeta, stid;
      grunt.verbose.writeln("Generating site");
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      families = metadata.families;
      pervasiveIdeas = sources.pervasiveIdeas;
      pervasiveIdeasHome = sources.pervasiveIdeasHome;
      resources = sources.resources;
      resourceTypes = sources.resourceTypes;
      stations = sources.stations;
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
      meta = sources.index.meta;
      layout = getLayout(sources, null, meta);
      html = grunt.template.process(grunt.file.read(layout), {
        data: {
          _head: _head,
          _nav: _nav,
          _foot: _foot,
          meta: meta,
          content: grunt.file.read(partialsDir + "/index.html"),
          sources: sources,
          rootUrl: '.',
          resourcesUrl: './resources'
        }
      });
      grunt.file.write(appDir + "/index.html", html);
      meta = sources['map'].meta;
      layout = getLayout(sources, null, meta);
      content = grunt.file.read(partialsDir + "/map.html");
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
      grunt.file.write(appDir + "/map.html", html);
      meta = pervasiveIdeasHome.meta;
      layout = getLayout(sources, null, meta);
      html = grunt.template.process(grunt.file.read(layout), {
        data: {
          _head: _head,
          _nav: _nav,
          _foot: _foot,
          content: grunt.file.read(partialsDir + "/pervasiveIdeasHome.html"),
          meta: meta,
          families: families,
          pervasiveIdeas: pervasiveIdeas,
          rootUrl: '.',
          resourcesUrl: './resources'
        }
      });
      grunt.file.write(appDir + "/pervasiveIdeasHome.html", html);
      for (pvid in pervasiveIdeas) {
        data = pervasiveIdeas[pvid];
        meta = data.meta;
        layout = getLayout(sources, 'pervasiveIdeas', meta);
        html = grunt.template.process(grunt.file.read(layout), {
          data: {
            _piMenu: _piMenu,
            _head: _head,
            _nav: _nav,
            _foot: _foot,
            meta: meta,
            content: getPervasiveIdeaData(pvid, meta),
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
      /*
      for eqid, data of examQuestions
        indexMeta = data.index?.meta
        solutionMeta = data.solution?.meta
        layout = getLayout sources, 'examQuestion', indexMeta
        content = getExamQuestionData eqid, data, indexMeta
        html = grunt.template.process grunt.file.read(layout), {
          data:
            _head: _head
            _nav: _nav
            _foot: _foot
            content: content
            meta: indexMeta
            solutionMeta: solutionMeta
            rootUrl: '../..'
            resourcesUrl: '..'
        }
        grunt.file.write "app/examQuestions/#{eqid}/index.html", html
      */
      for (resourceName in resources) {
        files = resources[resourceName];
        indexMeta = files.index.meta;
        layout = getLayout(sources, 'resources', indexMeta);
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
      for (stid in stations) {
        data = stations[stid];
        meta = data.meta;
        layout = getLayout(sources, 'stations', meta);
        html = grunt.template.process(grunt.file.read(layout), {
          data: {
            _head: _head,
            _nav: _nav,
            _foot: _foot,
            _linesMenu: _linesMenu,
            meta: meta,
            content: grunt.file.read(partialsDir + "/stations/" + stid + ".html"),
            sources: sources,
            rootUrl: "..",
            resourcesUrl: '../resources'
          }
        });
        grunt.file.write(appDir + "/stations/" + stid + ".html", html);
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
