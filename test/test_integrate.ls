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
describe "Testing integrate task", (_it) ->

  before ->
    grunt.log.ok "integrate test"

  describe ".isolate", (_it) ->
    it "should not exist", ->
      (grunt.file.exists ".isolate").should.not.be.ok


