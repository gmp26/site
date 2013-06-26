#
# This file runs Mocha tests over the lib sources.
#
# Using make instead of grunt because mocha throws uncaught exceptions which
# cause grunt to bail out, and the published getarounds look a little unstable.
#
REPORTER = spec

objects = $(patsubst test/%.ls,test/%.js,$(wildcard test/*.ls))
lib = $(patsubst lib/%.ls,lib/%.js,$(wildcard lib/*.ls))
js = $(objects) $(lib)

all: test

$(lib): lib/%.js: lib/%.ls
	lsc -c $<

$(objects):	test/%.js: test/%.ls
	lsc -c $<

test: $(js)
	@NODE_ENV=test ./node_modules/.bin/mocha \
		--reporter $(REPORTER) \
		--ui bdd

.PHONY: test
