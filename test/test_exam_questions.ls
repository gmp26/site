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
describe "Testing exam questions", (_it)->

  var metadata

  before ->
    metadata := grunt.config.get "metadata"

  describe "dummy passing test", (_it) ->
    it "should be false", ->
      true.should.equal true
