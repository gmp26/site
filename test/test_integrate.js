/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing integrate task", function(_it){
    before(function(){
      return grunt.log.ok("integrate test");
    });
    return describe(".isolate", function(_it){
      return it("should not exist", function(){
        return grunt.file.exists(".isolate").should.not.be.ok;
      });
    });
  });
}).call(this);
