/*
global describe, it
*/
(function(){
  "use strict";
  var cssParser, should, grunt, _;
  cssParser = require('css-parse');
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing line colour generation", function(_it){
    var metadata, expanded, lines;
    before(function(){
      var foo;
      metadata = grunt.config.get("metadata");
      lines = metadata.sources.lines;
      debugger;
      return foo = cssParser('.lineA {\n  color: #9467bd\n}\n\n.lineC {\n  color: #bcbd22\n}');
    });
    return describe("line metadata", function(_it){
      it("should provide colours for each line", function(){
        return _.each(lines, function(line){
          var meta;
          meta = line.meta;
          return meta.should.have.property('colour');
        });
      });
      it("should generate app/styles/lineVars.less", function(){
        return grunt.file.exists('app/styles/lineVars.less').should.be['true'];
      });
      it("app/styles/lineVars.less should contain valid css", function(){
        var css;
        css = grunt.file.read("app/styles/lineVars.less");
        return function(){
          return cssParser(css);
        }.should.not['throw']();
      });
      it("should contain a class for each line", function(){
        var css, tree;
        css = grunt.file.read("app/styles/lineVars.less");
        tree = cssParser(css);
        return _.size(tree.stylesheet.rules).should.equal(_.size(lines));
      });
      return it("should contain correct line colours", function(){
        var css, tree;
        css = grunt.file.read("app/styles/lineVars.less");
        tree = cssParser(css);
        return _.each(tree.stylesheet.rules, function(rule){
          var lineId, colour, lineCode, ref$;
          lineId = rule.selectors[0];
          colour = rule.declarations[0].value;
          lineCode = lineId.substr(".line".length);
          grunt.log.ok("line " + lineId + ", colour " + colour);
          return colour.should.equal((ref$ = lines[lineCode]) != null ? ref$.meta.colour : void 8);
        });
      });
    });
  });
}).call(this);
