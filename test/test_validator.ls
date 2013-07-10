/*
global describe, it
*/
"use strict"

should = require("chai").should()
grunt = require 'grunt'

#
# NB 'it' is a reserved word in livescript, meaning an unspecified parameter,
# so passing (_) from describe to allow it to be overridden.
#
describe "Testing validator", (_)->

  var metadata
  var sources
  var lines
  var stations
  var resources
  var resourceTypes
  var pervasiveIdeas

  before ->
    metadata := grunt.config.get "metadata"
    sources := metadata.sources
    lines := sources.lines
    stations := sources.stations
    resources := sources.resources
    resourceTypes := sources.resourceTypes
    pervasiveIdeas := sources.pervasiveIdeas

  describe "checking lines", (_) ->
    it "should delete bad lines", ->
      should.not.exist(lines["bad-lineName"])

  describe "checking stations", (_) -> 
    it "should delete bad stations", ->
      should.not.exist(stations["BAD"])
      should.not.exist(stations["BAD2"])
      should.not.exist(stations["BAD10"])

  describe "checking pervasiveIdeas", (_) -> 
    it "should delete bad pervasiveIdeas", ->
      should.not.exist(pervasiveIdeas["bad-pvMissingTitle"])
      should.exist(pervasiveIdeas["bad-pvMissingFamily"])

  describe "checking resources", (_) -> 
    it "should delete bad resources, but not ones with missing refs", ->
      should.not.exist(resources["bad-NotInFolder"])
      should.not.exist(resources["bad-missingRT"])
      should.exist(resources["ok-missingRefs"])

  describe "resource missing refs should be deleted", (_) ->
    it "should delete missing refs from resources", ->
      mr = resources["ok-missingRefs"].index.meta
      mr.stids1.indexOf("G99").should.equal -1
      mr.stids2.indexOf("G100").should.equal -1
      mr.pvids1.indexOf("PI99").should.equal -1
      mr.pvids2.indexOf("PI100").should.equal -1





