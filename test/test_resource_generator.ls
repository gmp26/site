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
  var partialsDir
  var getResourceData
  var resourceName
  var files
  var indexMeta
  var data


  before ->
    metadata := grunt.config.get "metadata"
    sources := metadata.sources
    resources := sources.resources
    partialsDir := grunt.config.get "yeoman.partials"
    getResourceData := (require '../lib/getResourceData.js') grunt, sources, partialsDir

  beforeEach ->
    resourceName := 'G2_RT3'
    files := resources.G2_RT3
    indexMeta := files.index.meta
    data := getResourceData resourceName, files, indexMeta

  describe "G2_RT3", (_it) ->
    it "should be an object", ->
      data.should.be.instanceof Object
    it "should contain a sidebar object", ->
      data.sidebar.should.be.instanceof Object
    it "should contain a parts Array", ->
      data.parts.should.be.instanceof Array
    it  "should contain stMetas array", ->
      data.sidebar.stMetas.should.be.instanceof Array
    it  "should contain G2 in stids1 G2", ->
      data.sidebar.stMetas.0.id.should.eql 'G2'
    it  "should contain pvMetas", ->
      data.sidebar.pvMetas.should.be.instanceof Array
    it  "should contain pvMetas PI3", ->
      data.sidebar.pvMetas.0.id.should.eql 'PI3'
    it  "should contain pvMetas PI4", ->
      data.sidebar.pvMetas.1.id.should.eql 'PI4'
    it "should have 3 parts", ->
      data.parts.length.should.equal 3
    it "parts should be sorted by weight", ->
      data.parts.0.alias.should.equal 'Problem'
      data.parts.1.alias.should.equal 'Solution'
      data.parts.2.alias.should.equal "Teachers' Notes"

