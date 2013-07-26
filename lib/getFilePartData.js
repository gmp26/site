(function(){
  "use strict";
  module.exports = function(grunt, sources, partialsDir, folder){
    return function(resourceName, files, indexMeta){
      var _, weightOf, aliasOf, contentOf;
      _ = grunt.util._;
      weightOf = function(fileName, fileMeta){
        if (fileName === "index") {
          return 0;
        }
        if (!(fileMeta != null && fileMeta.weight)) {
          return fileName;
        }
        return fileMeta.weight;
      };
      aliasOf = function(fileName, fileMeta){
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
            alias: aliasOf(fileName, file.meta),
            html: grunt.file.read(pDir + "/" + folder + "/" + rName + "/" + fileName + ".html")
          };
        }
        return _.sortBy(content, function(cdata){
          return weightOf(cdata.fileName, cdata.fileMeta);
        });
      };
      return contentOf(files);
    };
  };
}).call(this);
