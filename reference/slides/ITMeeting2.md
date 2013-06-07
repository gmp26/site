#CMEP IT Summary


10 June 2013

#Agenda

- Development Process

- Definitions

- The CMEP curriculum site

- The LinkedIn discussion site

- Discussion

#The Development Process

![The Development Process](Development_process_v1.png)

#Definitions


- __`Git`__ is a modern distributed version control system written by Linus Torvalds - the man who wrote the Linux kernel.
- __`Git`__ is widely used for development and is beginning to be taken up in other spheres such as design.
  	- Each CMEP author and developer has a local copy of `Git` installed.
  	- `Git` makes it easy to merge local copies into final canonical versions.
  	- Contributors do not need to use `Git`

- A __repository__ is a collection of files managed by `Git`.
	- The CMEP repository for the curriculum site is called [CMEP-site](https://github.com/CMEPorg/CMEP-site)
	- Each author and developer has a local copy of [CMEP-site](https://github.com/CMEPorg/CMEP-site).
	- Contributors do not have access 

- __[`GitHub`](http://github.com)__ is a cloud service that makes use of `Git`. 
	- It's an extremely useful service, but we are not in any way dependent on its continued existence. 
	- We have a `GitHub` account, enabling us to keep a copy of the [CMEP-site](https://github.com/CMEPorg/CMEP-site) repository private there.
	- On top of version control, `GitHub` provides:
		- Compilation of `Markdown` documents into viewable web pages
		- An Issues tracker
		- A Web editor
		- Easy access to the change history - who did what and when
		- Activity tracking
		- Change notifications.

- __`Markdown`__ is a wiki-like markup language.
	- `GitHub` displays `Markdown` files nicely so we can preview resources there.

- __[`Pandoc`](http://johnmacfarlane.net/pandoc)__ is a document converter written in Haskell.
	- It is an [open source Haskell program](https://code.google.com/p/pandoc/downloads/list).
	- It can compile `Markdown`, HTML and _core_ `LaTeX` into HTML, `TeX`, Word documents, pdf, e-book, and slides.
	- It uses `LaTeX` for mathematics notation.
	- It can embed HTML to cope with special requirements such as embedded interactives.

- __[`YAML`](http://www.yaml.org/)__ is Yet Another Markup Language. We are using it to annotate documents with metadata.

- CMEP source documents contain:
	- a metadata header in `YAML`
	- content in `Pandoc flavour Markdown`.

See the [resource template here](https://github.com/CMEPorg/CMEP-site/tree/master/sources/resources/template)

- The unfortunately named __[`Grunt`](http://gruntjs.com/)__ is a task runner, which we will use to run the various tasks that convert source material into web sites and other output forms.
	- For example we have written a grunt task [grunt-panda](http://gruntjs.com/plugins/pandoc) to run pandoc over directories of markdown sources.

#The CMEP curriculum site


- All source material for the site lives in [CMEP-site/sources](https://github.com/CMEPorg/CMEP-site/tree/master/sources).

- We'll be compiling these sources into the various preview and production sites, sub-sites, and review copies.
	- local preview for authors
	- limited previews for contributors
	- level 1 to 5 distributions for the various reviewers as in Vicky's memo
	- published version

- We expect the final site(s) will not need a database or any active server-side processing. 
	- It should therefore be
		- very fast
		- and very secure.

#LinkedIn Discussion Site


- Why LinkedIn?
	- It's seen as the leading social networking site for professionals
	- It offers closed access discussion groups.
	- [LinkedIn Group Demo](http://www.linkedin.com/myGroups?trk=nav_responsive_sub_nav_groups)

- We need a name for the new group

#Q&A


- Post Graduate help
	- 2 candidates applied
	- on hold pending part III exams

- More shopping
	- A UPS power supply for the new server
	- A laptop for Steve when he returns
	- UCS copies of Office for Vicky/Steve laptops
	 
