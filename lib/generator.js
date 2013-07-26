(function(){
  "use strict";
  module.exports = function(grunt){
    var getLayout, _;
    getLayout = require('./getLayout.js')(grunt);
    _ = grunt.util._;
    return grunt.registerTask("generator", "Generate the site html, javascripts and CSS.", function(){
      var metadata, sources, families, pervasiveIdeas, pervasiveIdeasHome, examQuestions, resources, resourceTypes, stations, sourcesDir, partialsDir, appDir, _head, _nav, _foot, _linesMenu, _piMenu, getExamQuestionPartData, getResourceData, getPervasiveIdeaData, meta, layout, html, content, pvid, data, st13s, pi13s, eqid, indexMeta, ref$, i$, len$, id, rt13, stid, rt13Sorted, rt13html, resid, R1s, ref1$, resourceName, files;
      grunt.verbose.writeln("Generating site");
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      families = metadata.families;
      pervasiveIdeas = sources.pervasiveIdeas;
      pervasiveIdeasHome = sources.pervasiveIdeasHome;
      examQuestions = sources.examQuestions;
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
      getExamQuestionPartData = require('./getFilePartData.js')(grunt, sources, partialsDir, 'examQuestions');
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
      st13s = {};
      pi13s = {};
      for (eqid in examQuestions) {
        data = examQuestions[eqid];
        indexMeta = (ref$ = data.index) != null ? ref$.meta : void 8;
        layout = getLayout(sources, 'renderQuestion', null);
        content = getExamQuestionPartData(eqid, data, indexMeta);
        html = grunt.template.process(grunt.file.read(layout), {
          data: {
            content: content,
            rootUrl: '../..',
            resourcesUrl: '..'
          }
        });
        grunt.file.write(partialsDir + "/renderedQuestions/" + eqid + "/index.html", html);
        if (indexMeta.stids1 != null) {
          for (i$ = 0, len$ = (ref$ = indexMeta.stids1).length; i$ < len$; ++i$) {
            id = ref$[i$];
            st13s[id] == null && (st13s[id] = {});
            rt13 = st13s[id];
            rt13[eqid] = true;
          }
        }
        if (indexMeta.pvids1 != null) {
          for (i$ = 0, len$ = (ref$ = indexMeta.pvids1).length; i$ < len$; ++i$) {
            id = ref$[i$];
            pi13s[id] == null && (pi13s[id] = {});
            rt13 = pi13s[id];
            rt13[eqid] = true;
          }
        }
      }
      for (stid in st13s) {
        rt13 = st13s[stid];
        rt13Sorted = _.sortBy(_.keys(rt13), fn$);
        debugger;
        rt13html = rt13Sorted.map(fn1$).join("<hr />\n");
        resid = stid + "_RT13";
        grunt.file.write(partialsDir + "/resources/" + resid + "/index.html", rt13html);
        resources[resid] = {
          index: {
            meta: {
              id: resid,
              layout: 'eqresource',
              resourceType: 'RT13'
            }
          }
        };
        R1s = (ref$ = (ref1$ = stations[stid].meta) != null ? ref1$.R1s : void 8) != null
          ? ref$
          : [];
        R1s[R1s.length] = {
          id: resid,
          rt: 'RT13',
          highlight: null
        };
      }
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
        grunt.file.write(appDir + "/resources/" + resourceName + "/index.html", html);
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
      function fn$(k){
        return +k.substr(1);
      }
      function fn1$(eqid){
        return grunt.file.read(partialsDir + "/renderedQuestions/" + eqid + "/index.html");
      }
    });
  };
}).call(this);
