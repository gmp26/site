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
describe "Testing resources expansion", (_it)->

  var metadata
  var expanded
  var resources
  var res

  before ->
    metadata := grunt.config.get "metadata"
    resources := metadata.sources.resources
    res := resources.G2_RT2

  describe "good resources should exist", (_it) ->
    it "G2_RT2 should exist", ->
      should.exist resources.G2_RT2
    it "G2_RT3 should exist", ->
      should.exist resources.G2_RT3
    it "G2_RT7 should exist", ->
      should.exist resources.G2_RT7
    it "ok-missingLayout1 should exist", ->
      should.exist resources.["ok-missingLayout1"]
    it "ok-missingRefs should exist", ->
      should.exist resources.["ok-missingRefs"]
    it "ok-refPVmissingTitle should exist", ->
      should.exist resources.["ok-refPVmissingTitle"]
    it "PI1_RT15 should exist", ->
      should.exist resources.PI1_RT15
    it "PI1_RT4 should exist", ->
      should.exist resources.PI2_RT4

  describe "bad resources should not exist", (_it) ->
    it "bad-missingIndex should not exist", ->
      should.not.exist resources.["bad-missingIndex"]
    it "bad-missingRT should not exist", ->
      should.not.exist resources.["bad-missingRT"]
    it "bad-NotInFolder should not exist", ->
      should.not.exist resources.["bad-NotInFolder"]

  describe "G2_RT2 resource", (_it) ->

    it "index metadata should exist",  ->
      should.exist res.index.meta

    # solution exists, but solution.meta may be null
    it "solution should exist",  ->
      should.exist res.solution


 
 


