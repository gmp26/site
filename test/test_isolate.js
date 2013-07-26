/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing isolate task", function(_it){
    before(function(){
      return grunt.log.ok("isolate test");
    });
    return describe("token", function(_it){
      return it("should be saved", function(){
        var token;
        token = grunt.file.read(".isolate");
        return token.should.equal("(EQ1)|(G2)");
      });
    });
  });
}).call(this);
