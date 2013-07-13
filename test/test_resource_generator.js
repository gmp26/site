/*
global describe, it
*/
(function(){
  "use strict";
  var should, grunt, _;
  should = require("chai").should();
  grunt = require('grunt');
  _ = grunt.util._;
  describe("Testing resource data generation", function(_it){
    var metadata, sources, resources, partialsDir, getResourceData, resourceName, files, indexMeta, data;
    before(function(){
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      resources = sources.resources;
      partialsDir = grunt.config.get("yeoman.partials");
      return getResourceData = require('../lib/getResourceData.js')(grunt, sources, partialsDir);
    });
    beforeEach(function(){
      resourceName = 'G2_RT3';
      files = resources.G2_RT3;
      indexMeta = files.index.meta;
      return data = getResourceData(resourceName, files, indexMeta);
    });
    return describe("G2_RT3", function(_it){
      it("should be an object", function(){
        return data.should.be['instanceof'](Object);
      });
      it("should contain a sidebar object", function(){
        return data.sidebar.should.be['instanceof'](Object);
      });
      it("should contain a parts Array", function(){
        return data.parts.should.be['instanceof'](Array);
      });
      it("should contain stMetas array", function(){
        return data.sidebar.stMetas.should.be['instanceof'](Array);
      });
      it("should contain G2 in stids1 G2", function(){
        return data.sidebar.stMetas[0].id.should.eql('G2');
      });
      it("should contain pvMetas", function(){
        return data.sidebar.pvMetas.should.be['instanceof'](Array);
      });
      it("should contain pvMetas PI3", function(){
        return data.sidebar.pvMetas[0].id.should.eql('PI3');
      });
      it("should contain pvMetas PI4", function(){
        return data.sidebar.pvMetas[1].id.should.eql('PI4');
      });
      it("should have 3 parts", function(){
        return data.parts.length.should.equal(3);
      });
      return it("parts should be sorted by weight", function(){
        data.parts[0].alias.should.equal('Problem');
        data.parts[1].alias.should.equal('Solution');
        return data.parts[2].alias.should.equal("Teachers' Notes");
      });
    });
  });
}).call(this);
