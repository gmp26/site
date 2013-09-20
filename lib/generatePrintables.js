(function(){
  "use strict";
  module.exports = function(grunt){
    var getLayout, fs, _;
    getLayout = require('./getLayout.js')(grunt);
    fs = require('fs');
    _ = grunt.util._;
    return grunt.registerTask("generatePrintables", "Generate printable pdf versions of pages in the site.", function(){
      var metadata, sources, families, pervasiveIdeas, pervasiveIdeasHome, examQuestions, resources, resourceTypes, resourceTypesHome, stations, sourcesDir, partialsDir, appDir, _preamble, copyImage, copyResourceAssets, getResourceData, stid, data, meta, layout, markup, texFilename, texPath, resourceName, files, indexMeta, content;
      grunt.verbose.writeln("Generating printables");
      grunt.config.set("layoutPostfix", ".tex");
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      families = metadata.families;
      pervasiveIdeas = sources.pervasiveIdeas;
      pervasiveIdeasHome = sources.pervasiveIdeasHome;
      examQuestions = sources.examQuestions;
      resources = sources.resources;
      resourceTypes = sources.resourceTypes;
      resourceTypesHome = sources.resourceTypesHome;
      stations = sources.stations;
      sourcesDir = grunt.config.get("yeoman.sources");
      partialsDir = grunt.config.get("yeoman.partials");
      appDir = grunt.config.get("yeoman.app");
      _preamble = grunt.file.read("layouts/_printablesPreamble.tex");
      copyImage = function(filename, targetFolder){
        return grunt.file.copy(appDir + "/images/" + filename, partialsDir + "/printables/" + targetFolder + "/" + filename);
      };
      copyResourceAssets = function(name){
        var files, i$, len$, img, results$ = [];
        files = grunt.file.expand(sourcesDir + "/resources/" + name + "/*.png");
        for (i$ = 0, len$ = files.length; i$ < len$; ++i$) {
          img = files[i$];
          results$.push(grunt.file.copy(img, img.replace(sourcesDir + "", partialsDir + "/printables")));
        }
        return results$;
      };
      getResourceData = require('./getResourceData.js')(grunt, sources, partialsDir + '/printables');
      copyImage('postmark.pdf', 'stations');
      copyImage('cmep-logo3.pdf', 'stations');
      for (stid in stations) {
        data = stations[stid];
        meta = data.meta;
        layout = getLayout(sources, 'stations', meta);
        markup = grunt.template.process(grunt.file.read(layout), {
          data: {
            _preamble: _preamble.replace('<%= fontpath %>', '../../../app/fonts/'),
            meta: meta,
            content: grunt.file.read(partialsDir + "/printables/stations/" + stid + ".tex"),
            sources: sources
          }
        });
        texFilename = stid + ".printable.tex";
        texPath = partialsDir + "/printables/stations/" + texFilename;
        grunt.file.write(texPath, markup);
      }
      for (resourceName in resources) {
        files = resources[resourceName];
        copyResourceAssets(resourceName);
        copyImage('cmep-logo3.pdf', "resources/" + resourceName);
        indexMeta = files.index.meta;
        layout = getLayout(sources, 'resources', indexMeta);
        content = getResourceData(resourceName, files, indexMeta);
        _.each(content.parts, fn$);
      }
      return metadata;
      function fn$(cdata, index){
        var markup, texFilename, resourcePath, texPath;
        markup = grunt.template.process(grunt.file.read(layout), {
          data: {
            _preamble: _preamble.replace('<%= fontpath %>', '../../../../app/fonts/'),
            resourceTypeMeta: sources.resourceTypes[indexMeta.resourceType].meta,
            content: cdata.markup,
            alias: cdata.alias,
            meta: indexMeta,
            sidebar: content.sidebar,
            icon: function(name){
              return '\\' + name.replace(/-/g, '');
            },
            stationbutton: function(stMeta){
              return ("\\definecolor{tempcolor}{HTML}{" + stMeta.colour.substring(1).toUpperCase() + "}%\n") + "\\begin{tikzpicture}[baseline=(n.base)]%\n" + "  \\node[rectangle, rounded corners=8pt, fill=tempcolor, text centered] (n) " + ("at (0,0) {\\hyperref[station:" + stMeta.id + "]{\\large\\sectfont\\color{white} " + stMeta.id + "}};%\n") + "\\end{tikzpicture}%\n";
            }
          }
        });
        texFilename = cdata.fileName + ".printable.tex";
        resourcePath = partialsDir + "/printables/resources/" + resourceName;
        texPath = resourcePath + "/" + texFilename;
        return grunt.file.write(texPath, markup);
      }
    });
  };
}).call(this);
