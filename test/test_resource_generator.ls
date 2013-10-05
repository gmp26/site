/*
global describe, it
*/
"use strict"

should = require("chai").should()
grunt = require 'grunt'
_ = grunt.util._

#
# NB 'it' is a reserved word in livescript, meaning an unspecified parameter,
# so passing (_it) from describe to allow 'it' to be overridden.
#
describe "Testing resource data generation", (_it)->

  var metadata
  var sources
  var resources
  var partialsHtmlDir
  var getResourceData
  var data
  var data1


  before ->
    metadata := grunt.config.get "metadata"
    sources := metadata.sources
    resources := sources.resources
    partialsHtmlDir := grunt.config.get("yeoman.partials") + "/html"
    getResourceData := (require '../lib/getResourceData.js') grunt, sources, partialsHtmlDir

    resourceName = 'G2_RT3'
    files = resources.G2_RT3
    indexMeta = files.index.meta
    data := getResourceData resourceName, files, indexMeta

    resourceName1 = 'G2_RT7'
    files1 = resources.G2_RT7
    indexMeta1 = files1.index.meta
    data1 := getResourceData resourceName1, files1, indexMeta1

  describe "G2_RT3", (_it) ->
    it "should be an object", ->
      data.should.be.instanceof Object
    it "should contain a sidebar object", ->
      data.sidebar.should.be.instanceof Object
    it "should contain a parts Array", ->
      data.parts.should.be.instanceof Array
    it  "should contain stMetas array", ->
      data.sidebar.stMetas.should.be.instanceof Array
    it "should contain G2 in stids1 G2", ->
      data.sidebar.stMetas.0.id.should.eql 'G2'
    it "should contain pvMetas", ->
      data.sidebar.pvMetas.should.be.instanceof Array
    it "should contain pvMetas PI3", ->
      data.sidebar.pvMetas.0.id.should.eql 'PI3'
    it "should contain pvMetas PI4", ->
      data.sidebar.pvMetas.1.id.should.eql 'PI4'
    it "should have 3 parts", ->
      data.parts.length.should.equal 3
    it "should have parts sorted by weight", ->
      data.parts.0.alias.should.equal 'Problem'
      data.parts.1.alias.should.equal 'Solution'
      data.parts.2.alias.should.equal "Teachers' Notes"
    it "should contain priorMetas in the sidebar", ->
      should.exist data.sidebar.priorMetas
      data.sidebar.priorMetas.should.be.instanceof Array
      data.sidebar.priorMetas.length.should.equal 2
    it "should contain priorMetas id" ->
      data.sidebar.priorMetas.0.should.have.property 'id'
    it "should contain priorMeta sorted by weight" ->
      data.sidebar.priorMetas.0.id.should.equal 'G2_RT7'
    it "should contain good priorMetas rtMeta" ->
      data.sidebar.priorMetas.0.should.have.property 'rtMeta'
      console.log "rtMeta==#{data.sidebar.priorMetas.0.rtMeta.id}"
      console.log "rtMeta==#{data.sidebar.priorMetas.0.rtMeta.weight}"
      data.sidebar.priorMetas.0.rtMeta.should.have.property 'id'
      data.sidebar.priorMetas.0.rtMeta.id.should.equal 'RT7'


  describe "G2_RT7", (_it) ->
    it "should be an object", ->
      data1.should.be.instanceof Object
    it "should contain a sidebar object", ->
      data1.sidebar.should.be.instanceof Object
    it "should contain a parts Array", ->
      data1.parts.should.be.instanceof Array
    it  "should contain stMetas array", ->
      data1.sidebar.stMetas.should.be.instanceof Array
    it "should contain G2 in stids1 G2", ->
      data1.sidebar.stMetas.0.id.should.eql 'G2'
    it "should not contain pvMetas", ->
      data1.sidebar.should.not.have.property 'pvMetas'
    it "should have 2 parts", ->
      data1.parts.length.should.equal 2
    it "should contain laterMetas in the sidebar", ->
      should.exist data1.sidebar.laterMetas
      data1.sidebar.laterMetas.should.be.instanceof Array
      data1.sidebar.laterMetas.length.should.equal 1
    it "should contain good laterMetas rtMeta" ->
      data1.sidebar.laterMetas.0.should.have.property 'rtMeta'
      data1.sidebar.laterMetas.0.rtMeta.should.have.property 'id'
      data1.sidebar.laterMetas.0.id.should.equal 'G2_RT3'
      data1.sidebar.laterMetas.0.rtMeta.id.should.equal 'RT3'


