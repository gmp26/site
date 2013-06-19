(function(){
  "use strict";
  module.exports = function(grunt){
    return function(metadata){
      var _, output, prevlinecolour, i, postreplace, stationname, ref$, data, linename, linecolour, dep, dept, ordered, replacement, next, reg, options;
      _ = grunt.util._;
      output = '';
      prevlinecolour = '';
      i = 0;
      postreplace = new Array();
      for (stationname in ref$ = metadata.stations) {
        data = ref$[stationname];
        linename = stationname.replace(/[0-9].*/g, '');
        linecolour = metadata.lines[linename].meta.colour;
        for (dep in data.meta.dependencies) {
          for (dept in data.meta.dependents) {
            if (data.meta.dependencies[dep] === data.meta.dependents[dept]) {
              ordered = _.sortBy([stationname, data.meta.dependents[dept]]);
              replacement = '"' + ordered[0] + '-' + ordered[1] + '"';
              postreplace[i++] = {
                "stationname": stationname,
                "replacement": replacement
              };
              stationname = replacement;
              data.meta.dependents[dept] = '';
            }
          }
        }
        for (dept in data.meta.dependents) {
          if (data.meta.dependents[dept] !== '') {
            if (linecolour !== prevlinecolour) {
              output = output + 'edge [style=bold ,color="' + linecolour + '"]\n';
              prevlinecolour = linecolour;
            }
            output = output + stationname + ' -> ' + data.meta.dependents[dept] + ' ;\n';
          }
        }
      }
      for (next in postreplace) {
        reg = new RegExp(postreplace[next].stationname + ' ', 'g');
        output = output.replace(reg, postreplace[next].replacement);
      }
      output = 'digraph G {node [shape=plaintext ,fillcolor="#EEF2FF", fontsize=16, fontname=arial]' + output + '}';
      grunt.file.write('partials/tubemap.dot', output);
      options = {
        cmd: '/opt/local/bin/dot',
        args: ['-Tsvg', '-opartials/tubemap.svg', 'partials/tubemap.dot']
      };
      return grunt.util.spawn(options, function(error, result, code){
        grunt.log.debug(code);
        if (!deepEq$(code, 0, '===')) {
          return grunt.log.error(result.stderr);
        }
      });
    };
  };
  function deepEq$(x, y, type){
    var toString = {}.toString, hasOwnProperty = {}.hasOwnProperty,
        has = function (obj, key) { return hasOwnProperty.call(obj, key); };
    first = true;
    return eq(x, y, []);
    function eq(a, b, stack) {
      var className, length, size, result, alength, blength, r, key, ref, sizeB;
      if (a == null || b == null) { return a === b; }
      if (a.__placeholder__ || b.__placeholder__) { return true; }
      if (a === b) { return a !== 0 || 1 / a == 1 / b; }
      className = toString.call(a);
      if (toString.call(b) != className) { return false; }
      switch (className) {
        case '[object String]': return a == String(b);
        case '[object Number]':
          return a != +a ? b != +b : (a == 0 ? 1 / a == 1 / b : a == +b);
        case '[object Date]':
        case '[object Boolean]':
          return +a == +b;
        case '[object RegExp]':
          return a.source == b.source &&
                 a.global == b.global &&
                 a.multiline == b.multiline &&
                 a.ignoreCase == b.ignoreCase;
      }
      if (typeof a != 'object' || typeof b != 'object') { return false; }
      length = stack.length;
      while (length--) { if (stack[length] == a) { return true; } }
      stack.push(a);
      size = 0;
      result = true;
      if (className == '[object Array]') {
        alength = a.length;
        blength = b.length;
        if (first) { 
          switch (type) {
          case '===': result = alength === blength; break;
          case '<==': result = alength <= blength; break;
          case '<<=': result = alength < blength; break;
          }
          size = alength;
          first = false;
        } else {
          result = alength === blength;
          size = alength;
        }
        if (result) {
          while (size--) {
            if (!(result = size in a == size in b && eq(a[size], b[size], stack))){ break; }
          }
        }
      } else {
        if ('constructor' in a != 'constructor' in b || a.constructor != b.constructor) {
          return false;
        }
        for (key in a) {
          if (has(a, key)) {
            size++;
            if (!(result = has(b, key) && eq(a[key], b[key], stack))) { break; }
          }
        }
        if (result) {
          sizeB = 0;
          for (key in b) {
            if (has(b, key)) { ++sizeB; }
          }
          if (first) {
            if (type === '<<=') {
              result = size < sizeB;
            } else if (type === '<==') {
              result = size <= sizeB
            } else {
              result = size === sizeB;
            }
          } else {
            first = false;
            result = size === sizeB;
          }
        }
      }
      stack.pop();
      return result;
    }
  }
}).call(this);
