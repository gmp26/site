(function(){
  "use strict";
  module.exports = function(grunt){
    return function(sources, folder, meta){
      var prefix, postfix, layout, m, ref$, using;
      prefix = 'layouts/';
      postfix = '.html';
      layout = meta != null ? meta.layout : void 8;
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
    };
  };
}).call(this);
