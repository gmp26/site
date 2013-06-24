CMEP-site
=========

These are the files necessary to generate  [the CMEP curriculum map](http://cambridge.maths.org) site.


>
> Warning:
>
> We currently generate only some of the intended site.
>


Directory organisation
----------------------

###app

The output folder used during development which allows the site to be previewed. When creating the site, use the command 'grunt server' to serve this directory on http://localhost:9000. Edits to the site will then (once this is all working) appear immediately in pages viewed there.

###dist

This is the production version of the site. Not currently in use.

###incoming

A holding pen for received material that has yet to be used.

###node_modules

A library of javascript modules installed by the node package manager. The scripts which build `app` and `dist` depend on these.

###reference

Reference material used by authors and developers that should not appear on site.

###sources
Files processed by the `grunt` and `grunt build` commands to generate the `app` preview image and the `dist` production image respectively.

####sources/layouts
These are html page layouts used by pages within the site. The documents in `sources/pages` are compiled into html and then inserted into one of these layouts in order to make a final html page. Pages indicate which layout to use by setting the 'layout' metadata field.

####sources/data
A data model for the site, mostly written in yaml. Not sure whether this will stay around.

####sources/files
Contains precompiled files e.g. html, images, pdfs, videos to be published as is. Will appear at <serverRootUrl>/files.

####sources/pervasiveIdeas
Markdown files containing pervasive ideas. See template.md for format.

####sources/resources
Markdown files containing resources. See template.md for format.

####sources/resourceTypes
Markdown files containing resource types. See template.md for format.

####sources/stations
Markdown files containing stations. See template.md for format.



Commands
--------

We use commands provided by the [`grunt`](http://gruntjs.com/) task runner for various site tasks. Run `grunt --help` in a terminal for the complete list. The main tasks are `grunt`, `grunt test`, `grunt server`, and `grunt build`. Other tasks listed by `grunt --help` are run as needed by the main tasks.

Getting started
---------------

### Prerequisites

Make sure you have [`node`](http://nodejs.org/) and [`grunt`](http://gruntjs.com/) and [`pandoc`](http://johnmacfarlane.net/pandoc/) installed.

### Installation

In a terminal, `cd` to a suitable parent directory, and clone the repository. If your parent directory is called `~/cmep`, this creates
~/cmep/CMEP_site.

```
cd ~/cmep
git clone git@github.com:CMEPorg/CMEP-site.git
```

Install the necessary node_modules used by the various grunt tasks.
```
npm install
```

Install the necessary libraries for client-side scripts.
```
bower install
```

From a shell, start a background watch and compile livescript task
```
./scripts/lswatch &
``` 

### Run

Create the development folder `app`, and serve it by starting a 
local web browser.
```
grunt server
```

### Create

Open a browser pointing at the app folder served ar http://localhost:9000. You can now edit files in the sources folder and preview the results in
your browser.


