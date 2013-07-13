/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing resourceType expansion", function(_it){
    var metadata, resourceTypes;
    before(function(){
      metadata = grunt.config.get("metadata");
      return resourceTypes = metadata.sources.resourceTypes;
    });
    return describe("resourceTypes", function(_it){
      return it("should carry weights", function(){
        return _.each(resourceTypes, function(rt, id){
          rt.should.have.property('meta');
          rt.meta.should.have.property('weight');
          return rt.meta.weight.should.be.a('number');
        });
      });
    });
  });
  describe("Testing resources expansion", function(_it){
    var metadata, expanded, resources, res, meta, pmeta;
    before(function(){
      metadata = grunt.config.get("metadata");
      resources = metadata.sources.resources;
      res = resources.G2_RT2;
      meta = resources.G2_RT3.index.meta;
      return pmeta = resources.G2_RT7.index.meta;
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
    describe("G2_RT2 resource", function(_it){
      it("index metadata should exist", function(){
        return should.exist(res.index.meta);
      });
      return it("solution should exist", function(){
        return should.exist(res.solution);
      });
    });
    return describe('priors', function(_it){
      it("should delete bad prior references", function(){
        return meta.priors.should.not.include('missing');
      });
      it("should not delete good prior references", function(){
        return meta.priors.should.include('G2_RT7');
      });
      it("should generate laters in prior", function(){
        return should.exist(pmeta.laters);
      });
      it("should generate a later pointing back", function(){
        return pmeta.laters.should.include('G2_RT3');
      });
      it("should not repeat priors", function(){
        return (meta.priors.lastIndexOf('G2_RT7') - meta.priors.indexOf('G2_RT7')).should.equal(0);
      });
      return it("should not repeat laters", function(){
        return (pmeta.laters.lastIndexOf('G2_RT3') - pmeta.laters.indexOf('G2_RT3')).should.equal(0);
      });
    });
  });
}).call(this);
