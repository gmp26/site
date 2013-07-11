(function(){
  "use strict";
  module.exports = function(grunt){
    var resourceLayout, _;
    _ = grunt.util._;
    return grunt.registerTask("generator", "Generate the site html, javascripts and CSS.", function(){
      var options, metadata, sources, stations, pervasiveIdeas, resources, resourceTypes, lines, sourcesDir, partialsDir, appDir, lastFolder, folder, items, resourceName, files, meta, fileName;
      grunt.verbose.writeln("Generating site");
      options = this.options({});
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      stations = sources.stations;
      pervasiveIdeas = sources.pervasiveIdeas;
      resources = sources.resources;
      resourceTypes = sources.resourceTypes;
      lines = sources.lines;
      sourcesDir = grunt.config.get("yeoman.sources");
      partialsDir = grunt.config.get("yeoman.partials");
      appDir = grunt.config.get("yeoman.app");
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
            meta = files.index.meta;
            generateResource(sources, folder, resourceName, files, meta);
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
      debugger;
      generateLess(sources);
      return metadata;
      function getLayout(sources, folder, meta){
        var prefix, postfix, layout, m, ref$, using;
        prefix = 'layouts/';
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
          using = prefix + 'default' + postfix;
          grunt.verbose.writeln(folder + " layout " + layout + " does not exist, using " + using);
          return using;
        }
      }
      function generateResource(sources, folder, resourceName, files, meta){
        var layout, mainParents, weightOf, getPart, _head, _nav, _foot, parents, content, fileName, file, html;
        layout = getLayout(sources, folder, meta);
        mainParents = function(meta){
          var stids1, ref$, ref1$, pvids1;
          stids1 = meta.stids1;
          if (_.isArray(stids1) && stids1.length > 0) {
            return ref$ = {
              type: "st",
              metas: _.sortBy(_.map(stids1, function(id){
                return stations[id].meta;
              }))
            }, ref$[ref1$ = function(it){
              return it.rank;
            }] = ref1$, ref$;
          }
          pvids1 = meta.pvids1;
          if (_.isArray(pvids1) && pvids1.length > 0) {
            return {
              type: "pv",
              metas: _.map(pvids1, function(id){
                return pervasiveIdeas[id].meta;
              })
            };
          }
          return null;
        };
        weightOf = function(fileName, fileMeta){
          if (fileName === "index") {
            return 0;
          }
          if (!(fileMeta != null && fileMeta.weight)) {
            return fileName;
          }
          return fileMeta.weight;
        };
        getPart = function(fileName, fileMeta){
          debugger;
          if ((fileMeta != null ? fileMeta.tab : void 8) != null) {
            return fileMeta.tab;
          } else if ((fileMeta != null ? fileMeta.id : void 8) != null) {
            return fileMeta.id;
          } else {
            return fileName;
          }
        };
        _head = grunt.file.read("layouts/_head.html");
        _nav = grunt.file.read("layouts/_nav.html");
        _foot = grunt.file.read("layouts/_foot.html");
        parents = mainParents(meta);
        if (parents) {
          content = [];
          for (fileName in files) {
            file = files[fileName];
            grunt.log.ok("fileName = " + fileName + ", tab = " + file.meta.tab + " part = " + getPart(fileName, file.meta));
            content[content.length] = {
              fileName: fileName,
              fileMeta: file.meta,
              part: getPart(fileName, file.meta),
              html: grunt.file.read(partialsDir + "/resources/" + resourceName + "/" + fileName + ".html")
            };
          }
          _.sortBy(content, function(cdata){
            return weightOf(cdata.fileName, cdata.fileMeta);
          });
          html = grunt.template.process(grunt.file.read(layout), {
            data: {
              _head: _head,
              _nav: _nav,
              _foot: _foot,
              resourceTypeMeta: sources.resourceTypes[meta.resourceType].meta,
              content: content,
              meta: meta,
              parents: parents,
              root: '../..',
              resources: '..'
            }
          });
        } else {
          grunt.log.error("*** Ignoring orphan resource " + folder + "/" + resourceName + " with no stids1 or pvids1");
        }
        return grunt.file.write("app/" + folder + "/" + resourceName + "/index.html", html);
      }
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
