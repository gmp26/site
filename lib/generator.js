(function(){
  "use strict";
  var slice$ = [].slice;
  module.exports = function(grunt){
    var getLayout, fs, _;
    getLayout = require('./getLayout.js')(grunt);
    fs = require('fs');
    _ = grunt.util._;
    return grunt.registerTask("generator", "Generate the site html, javascripts and CSS.", function(){
      var metadata, sources, families, pervasiveIdeas, pervasiveIdeasHome, examQuestions, resources, resourceTypes, resourceTypesHome, stations, sourcesDir, partialsDir, appDir, _head, _nav, _foot, _linesMenu, _piMenu, getExamQuestionPartData, getResourceData, getPervasiveIdeaData, generateTopLevelPage, pvid, data, meta, layout, html, acks, referenceFor, createStationRT13s, st13s, pi13s, eqid, indexMeta, ref$, content, i$, len$, id, rt13, stid, rt13Sorted, partition, key, subset, resid, resourceName, files;
      grunt.verbose.writeln("Generating site");
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
      _head = grunt.file.read("layouts/_head.html");
      _nav = grunt.file.read("layouts/_nav.html");
      _foot = grunt.file.read("layouts/_foot.html");
      _linesMenu = grunt.file.read("layouts/_linesMenu.html");
      _piMenu = grunt.file.read("layouts/_piMenu.html");
      getExamQuestionPartData = require('./getFilePartData.js')(grunt, sources, partialsDir, 'examQuestions');
      getResourceData = require('./getResourceData.js')(grunt, sources, partialsDir);
      getPervasiveIdeaData = require('./getPervasiveIdeaData.js')(grunt, sources, partialsDir);
      generateTopLevelPage = function(fname){
        var moreData, meta, layout, data, html;
        moreData = slice$.call(arguments, 1);
        meta = sources[fname].meta;
        layout = getLayout(sources, null, meta);
        data = {
          data: {
            _head: _head,
            _nav: _nav,
            _foot: _foot,
            meta: meta,
            content: grunt.file.read(partialsDir + "/" + fname + ".html"),
            sources: sources,
            rootUrl: '.',
            resourcesUrl: './resources'
          }
        };
        if (moreData != null) {
          _.extend(data.data, moreData[0]);
        }
        html = grunt.template.process(grunt.file.read(layout), data);
        return grunt.file.write(appDir + "/" + fname + ".html", html);
      };
      generateTopLevelPage('index');
      generateTopLevelPage('map', {
        _linesMenu: _linesMenu
      });
      generateTopLevelPage('index');
      generateTopLevelPage('pervasiveIdeasHome', {
        families: families,
        pervasiveIdeas: pervasiveIdeas
      });
      generateTopLevelPage('resourceTypesHome', {
        resourceTypes: _.sortBy(resourceTypes, function(data, rt){
          return +rt.substr(2);
        })
      });
      generateTopLevelPage('privacy');
      generateTopLevelPage('cookies');
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
      acks = grunt.file.readYAML(sourcesDir + "/examQuestions/sources.yaml");
      referenceFor = function(qmeta){
        var ref$;
        return {
          ref: [(ref$ = qmeta.paper) != null ? ref$ : "null", (ref$ = qmeta.year) != null ? ref$ : "null", qmeta.qno ? "Q" + qmeta.qno : "null"].join(', '),
          ack: qmeta.source ? acks[qmeta.source].acknowledgement : void 8
        };
      };
      createStationRT13s = function(stid, rt13Sorted, resid){
        var rt13html, i, i$, len$, eqid, dirFiles, j$, len1$, f, ext, R1s, ref$, ref1$, resMeta, insertAt;
        rt13html = "";
        i = 0;
        for (i$ = 0, len$ = rt13Sorted.length; i$ < len$; ++i$) {
          eqid = rt13Sorted[i$];
          rt13html += grunt.file.read(partialsDir + "/renderedQuestions/" + eqid + "/index.html").replace("!!Problem!!", (++i) + "");
        }
        grunt.file.write(partialsDir + "/resources/" + resid + "/index.html", rt13html);
        for (i$ = 0, len$ = rt13Sorted.length; i$ < len$; ++i$) {
          eqid = rt13Sorted[i$];
          dirFiles = fs.readdirSync(sourcesDir + "/examQuestions/" + eqid);
          for (j$ = 0, len1$ = dirFiles.length; j$ < len1$; ++j$) {
            f = dirFiles[j$];
            ext = f.substr(-4);
            if ('.png.gif.jpg.jpeg.PNG.GIF.JPG.JPEG'.indexOf(ext) >= 0) {
              grunt.log.debug(eqid + " -> " + f);
              grunt.file.copy(sourcesDir + "/examQuestions/" + eqid + "/" + f, appDir + "/resources/" + resid + "/" + f);
            }
          }
        }
        resources[resid] = {
          index: {
            meta: {
              id: resid,
              stids1: [stid],
              layout: 'eqresource',
              resourceType: 'RT13'
            }
          }
        };
        R1s = (ref$ = (ref1$ = stations[stid].meta) != null ? ref1$.R1s : void 8) != null
          ? ref$
          : [];
        resMeta = {
          id: resid,
          rt: 'RT13',
          highlight: null
        };
        insertAt = _.sortedIndex(R1s, resMeta, function(meta){
          var m, idWeight, weight;
          if (meta.id != null && _.isString(meta.id)) {
            m = meta.id.match(/_(\d+)$/);
            if (m !== null) {
              idWeight = +m[1] / 10;
            } else {
              idWeight = 0;
            }
          }
          weight = +meta.rt.substr(2) + idWeight;
          return +meta.rt.substr(2) + idWeight;
        });
        return R1s.splice(insertAt, 0, resMeta);
      };
      st13s = {};
      pi13s = {};
      for (eqid in examQuestions) {
        data = examQuestions[eqid];
        indexMeta = (ref$ = data.index) != null ? ref$.meta : void 8;
        layout = getLayout(sources, 'renderQuestion', null);
        grunt.log.debug("Calling getExamQuestionPart " + eqid);
        content = getExamQuestionPartData(eqid, data, indexMeta);
        content[0].alias = eqid + "";
        html = grunt.template.process(grunt.file.read(layout), {
          data: {
            content: content,
            reference: referenceFor(indexMeta),
            eqid: eqid,
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
        partition = _.groupBy(rt13Sorted, fn1$);
        for (key in partition) {
          subset = partition[key];
          resid = stid + "_RT13_EQ_" + key;
          createStationRT13s(stid, subset, resid);
        }
      }
      for (stid in stations) {
        data = stations[stid];
        meta = data.meta;
        layout = getLayout(sources, 'stations', meta);
        if (stid === 'G2') {
          debugger;
        }
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
      function fn1$(val, index){
        return Math.floor(index / 5);
      }
    });
  };
}).call(this);
