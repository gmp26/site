/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing exam questions", function(_it){
    var metadata;
    before(function(){
      return metadata = grunt.config.get("metadata");
    });
    return describe("dummy passing test", function(_it){
      return it("should be false", function(){
        return true.should.equal(true);
      });
    });
  });
}).call(this);
