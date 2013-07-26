(function(){
  "use strict";
  var slice$ = [].slice;
  module.exports = function(grunt){
    var root, store, replaceCount, metaReplacement;
    root = {};
    store = root;
    store.root = function(data, options){
      var ref$;
      if (data == null) {
        return root;
      }
      if (typeof data !== 'object') {
        throw new Error('store root must be object');
      }
      root = data;
      if ((options != null ? options.metaReplace : void 8) != null) {
        replaceCount = options.metaReplace.length;
        metaReplacement = (ref$ = options.metaReplacement) != null ? ref$ : "";
      } else {
        replaceCount = false;
      }
      return store;
    };
    store.setPathData = function(path, data){
      var accPaths, pathToObj;
      grunt.log.debug("before: path=" + path);
      if (replaceCount) {
        path = metaReplacement + path.substr(replaceCount);
      }
      grunt.log.debug("after: path=" + path);
      accPaths = function(names, data, acc){
        var head, tail;
        if (names.length === 0) {
          grunt.fatal("empty store path");
        }
        if (names.length === 1) {
          return acc[names[0]] = data;
        } else {
          head = names[0], tail = slice$.call(names, 1);
          if (!(acc[head] != null || typeof acc[head] === 'object')) {
            acc[head] = {};
          }
          return accPaths(tail, data, acc[head]);
        }
      };
      pathToObj = function(names, data, obj){
        if (typeof data !== 'object') {
          grunt.fatal("data is not an object: " + data);
        }
        names = names.filter(function(name){
          return name && name.length > 0;
        });
        return accPaths(names, data, obj);
      };
      pathToObj(path.split('/'), data, root);
      return store;
    };
    return store;
  };
}).call(this);
