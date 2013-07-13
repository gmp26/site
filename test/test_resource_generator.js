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
    var metadata, sources, resources, partialsDir, getResourceData, data, data1;
    before(function(){
      var resourceName, files, indexMeta, resourceName1, files1, indexMeta1;
      metadata = grunt.config.get("metadata");
      sources = metadata.sources;
      resources = sources.resources;
      partialsDir = grunt.config.get("yeoman.partials");
      getResourceData = require('../lib/getResourceData.js')(grunt, sources, partialsDir);
      resourceName = 'G2_RT3';
      files = resources.G2_RT3;
      indexMeta = files.index.meta;
      data = getResourceData(resourceName, files, indexMeta);
      resourceName1 = 'G2_RT7';
      files1 = resources.G2_RT7;
      indexMeta1 = files1.index.meta;
      return data1 = getResourceData(resourceName1, files1, indexMeta1);
    });
    describe("G2_RT3", function(_it){
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
      it("should have parts sorted by weight", function(){
        data.parts[0].alias.should.equal('Problem');
        data.parts[1].alias.should.equal('Solution');
        return data.parts[2].alias.should.equal("Teachers' Notes");
      });
      it("should contain priorMetas in the sidebar", function(){
        should.exist(data.sidebar.priorMetas);
        data.sidebar.priorMetas.should.be['instanceof'](Array);
        return data.sidebar.priorMetas.length.should.equal(2);
      });
      it("should contain priorMetas id", function(){
        return data.sidebar.priorMetas[0].should.have.property('id');
      });
      it("should contain priorMeta sorted by weight", function(){
        return data.sidebar.priorMetas[0].id.should.equal('G2_RT7');
      });
      return it("should contain good priorMetas rtMeta", function(){
        data.sidebar.priorMetas[0].should.have.property('rtMeta');
        console.log("rtMeta==" + data.sidebar.priorMetas[0].rtMeta.id);
        console.log("rtMeta==" + data.sidebar.priorMetas[0].rtMeta.weight);
        data.sidebar.priorMetas[0].rtMeta.should.have.property('id');
        return data.sidebar.priorMetas[0].rtMeta.id.should.equal('RT7');
      });
    });
    return describe("G2_RT7", function(_it){
      it("should be an object", function(){
        return data1.should.be['instanceof'](Object);
      });
      it("should contain a sidebar object", function(){
        return data1.sidebar.should.be['instanceof'](Object);
      });
      it("should contain a parts Array", function(){
        return data1.parts.should.be['instanceof'](Array);
      });
      it("should contain stMetas array", function(){
        return data1.sidebar.stMetas.should.be['instanceof'](Array);
      });
      it("should contain G2 in stids1 G2", function(){
        return data1.sidebar.stMetas[0].id.should.eql('G2');
      });
      it("should not contain pvMetas", function(){
        return data1.sidebar.should.not.have.property('pvMetas');
      });
      it("should have 1 part", function(){
        return data1.parts.length.should.equal(1);
      });
      it("should contain laterMetas in the sidebar", function(){
        should.exist(data1.sidebar.laterMetas);
        data1.sidebar.laterMetas.should.be['instanceof'](Array);
        return data1.sidebar.laterMetas.length.should.equal(1);
      });
      return it("should contain good laterMetas rtMeta", function(){
        data1.sidebar.laterMetas[0].should.have.property('rtMeta');
        data1.sidebar.laterMetas[0].rtMeta.should.have.property('id');
        data1.sidebar.laterMetas[0].id.should.equal('G2_RT3');
        return data1.sidebar.laterMetas[0].rtMeta.id.should.equal('RT3');
      });
    });
  });
}).call(this);
