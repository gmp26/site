CMEP-sources
============

This is the real content for CMEP-site.
---------------------------------------

Copied from CMEP-site/sources on Saturday 29th June 2013 at 15:52. A
record of the history before this date exists in the CMEP-site
repository.

Assuming that CMEP-site lives in parentDir/CMEP-site, please follow
these instructions:

1.  `cd parentDir`

2.  `git clone git@github.com:CMEPorg/CMEP-sources.git`. You should now
    have CMEP-site and CMEP-sources alongside each other.

3.  `cd CMEP-site` – change directory to the site

4.  `grunt clearance:0` – Clearance levels of 0 or above will cause
    CMEP-site to use this CMEP-sources directory. The location of
    CMEP-sources is in fact configurable in `Gruntfile.coffee` through
    the variable `yeomanConfig.content`. By default it is set to
    ‘../CMEP-sources’ - i.e. alongside CMEP-site.

5.  To switch to using the sample sources located at
    `yeomanConfig.samples` – which by default is the sources directory
    inside CMEP-site, say `grunt clearance:-1`. All negative clearance
    levels cause the sample sources to be used.

6.  To check at any time which sources are currently configured, use
    `grunt clearance`.

7.  The samples site shows a warning message on its home page.


