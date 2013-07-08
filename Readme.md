CMEP-site
=========

These are the files necessary to generate  [the CMEP curriculum map](http://cambridge.maths.org) site.

>
> Note:
>
> This directory contains sample content only.
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

Make sure you have [`node`](http://nodejs.org/),  
[`grunt`](http://gruntjs.com/), 
[`pandoc`](http://johnmacfarlane.net/pandoc/), and
[`graphviz`](http://www.graphviz.org/Download.php) installed.


### Installation

In a terminal, `cd` to a suitable parent directory, and clone the repository. If your parent directory is called `~/cmep`, this creates
~/cmep/CMEP-site.

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

From a shell, start a background watch and compile livescript task. This is 
only really necessary if doing code development.
```
./scripts/lswatch &
``` 

### Setting up for code development

Run the following command to set the repository to its internal sample and test content.
The variable `samples`
in the file `.clearance` defines the location of clearance level -1 content. 
`samples` is normally set up to point to the CMEP-site internal `sources` directory so it
is only necessary to install CMEP-site to have a working test system. 

```
grunt clearance:-1
```

### Setting up for content creation

Run one of these commands to set up the repository to use content cleared at the given level.
These commands require that the content directory is installed at the location specified 
by the `content` variable in the file `.clearance`. By default this is a directory named 
`CMEP-sources` sitting alongside this `CMEP-site` directory.

```
grunt clearance:0   -- include work in progress not intended for review
grunt clearance:1   -- prepare to build a site for internal team review 
grunt clearance:2   -- prepare to build a site for advisors and reviewers
grunt clearance:3   -- prepare to build a site for schools
grunt clearance:4   -- prepare to build a site for public pilot
grunt clearance:5   -- prepare to build a site for public release
```

### Run the site locally

Create the development folder `app`, and serve it by starting a 
local web browser.
```
grunt server
```

### Create

Open a browser pointing at the app folder served ar http://localhost:9000. You can now edit files in the sources folder and preview the results in
your browser.

### Creating and installing a distribution copy

Email Mike or Owen to run this part of the process as it requires server access rights.

Ensure you have set the clearance level for the site you wish to create using
a `grunt clearance:n` command. Then run

```
grunt server:dist
```

This will create an optimised version of the site, and open it locally in a browser for
test. Once the copy has been checked the `dist` folder can be uploaded to the appropriate site.



