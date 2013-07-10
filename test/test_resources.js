/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing resources expansion", function(_it){
    var metadata, expanded, resources, res;
    before(function(){
      metadata = grunt.config.get("metadata");
      resources = metadata.sources.resources;
      return res = resources.G2_RT2;
    });
    describe("good resources should exist", function(_it){
      it("G2_RT2 should exist", function(){
        return should.exist(resources.G2_RT2);
      });
      it("G2_RT3 should exist", function(){
        return should.exist(resources.G2_RT3);
      });
      it("G2_RT7 should exist", function(){
        return should.exist(resources.G2_RT7);
      });
      it("ok-missingLayout1 should exist", function(){
        return should.exist(resources["ok-missingLayout1"]);
      });
      it("ok-missingRefs should exist", function(){
        return should.exist(resources["ok-missingRefs"]);
      });
      it("ok-refPVmissingTitle should exist", function(){
        return should.exist(resources["ok-refPVmissingTitle"]);
      });
      it("PI1_RT15 should exist", function(){
        return should.exist(resources.PI1_RT15);
      });
      return it("PI1_RT4 should exist", function(){
        return should.exist(resources.PI2_RT4);
      });
    });
    describe("bad resources should not exist", function(_it){
      it("bad-missingIndex should not exist", function(){
        return should.not.exist(resources["bad-missingIndex"]);
      });
      it("bad-missingRT should not exist", function(){
        return should.not.exist(resources["bad-missingRT"]);
      });
      return it("bad-NotInFolder should not exist", function(){
        return should.not.exist(resources["bad-NotInFolder"]);
      });
    });
    return describe("G2_RT2 resource", function(_it){
      it("index metadata should exist", function(){
        return should.exist(res.index.meta);
      });
      return it("solution should exist", function(){
        return should.exist(res.solution);
      });
    });
  });
}).call(this);
