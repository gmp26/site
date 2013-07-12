(function(){
  "use strict";
  module.exports = function(grunt, sources, partialsDir){
    return function(layout, resourceName, files, indexMeta){
      var _, sidebarOf, weightOf, tabOf, contentOf;
      _ = grunt.util._;
      sidebarOf = function(indexMeta){
        var rv, stids1, pvids1;
        rv = null;
        stids1 = indexMeta.stids1;
        if (_.isArray(stids1) && stids1.length > 0) {
          rv == null && (rv = {});
          rv.stMetas = _.sortBy(_.map(stids1, function(id){
            return sources.stations[id].meta;
          }), function(it){
            return it.rank;
          });
        }
        pvids1 = indexMeta.pvids1;
        debugger;
        if (_.isArray(pvids1) && pvids1.length > 0) {
          rv == null && (rv = {});
          rv.pvMetas = _.map(pvids1, function(id){
            return sources.pervasiveIdeas[id].meta;
          });
        }
        return rv;
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
      tabOf = function(fileName, fileMeta){
        if ((fileMeta != null ? fileMeta.alias : void 8) != null) {
          return fileMeta.alias;
        } else if ((fileMeta != null ? fileMeta.id : void 8) != null) {
          return fileMeta.id;
        } else {
          return fileName;
        }
      };
      contentOf = function(files, pDir, rName){
        var content, fileName, file;
        pDir == null && (pDir = partialsDir);
        rName == null && (rName = resourceName);
        content = [];
        for (fileName in files) {
          file = files[fileName];
          content[content.length] = {
            fileName: fileName,
            fileMeta: file.meta,
            part: tabOf(fileName, file.meta),
            html: grunt.file.read(pDir + "/resources/" + rName + "/" + fileName + ".html")
          };
        }
        return _.sortBy(content, function(cdata){
          return weightOf(cdata.fileName, cdata.fileMeta);
        });
      };
      debugger;
      return {
        sidebar: sidebarOf(indexMeta),
        parts: contentOf(files)
      };
    };
  };
}).call(this);
