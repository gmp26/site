Summary of HTML page requirements
=================================

Keyword Search generally available

Home Page
---------

* Accordion of lines and stations
* Active tube map generated from YAML
* Student/Teacher intros in the menu
* Menu of Families of Pervasive Ideas

Lines
-----

* Dedicated lines pages are not linked in so far, but we do make them to
create lines metadata.

Stations
--------

* Show id and title colour coded to match line
* A Menu containing
	* Links Pervasive ideas (do not repeat)
	* Pervasive ideas in menu gleaned by:
		1. find resources which have this station in stids1 (same as the set displayed)
		2. form the union of pvids1 and pvids2 from these resources and list
	* Link to Teacher Support
	* Links to highlighted resources, listed by icon and resourceType
* Key Questions
	- compiled from Markdown
* Resources, listed by icon & resourceType which have this station in stids1
* Box showing dependencies
	linked colour coded id and title
* Box showing dependents
	linked colour coded id and title

Pervasive Idea page
-------------------

* Title (from markdown)
* Paragraph describing idea (from markdown)
* List of Articles (from metadata `articles`)
* Link to the Pervasive Idea Family
* A List of Resources containing this PI
	* Resources which have this pv listed on pvids1
* A List of Stations using this Pervasive Idea (generated)
	* Stations gleaned by:
		1. find resources with pv in pvids1 or 2
		2. form the union of stids1 from these resources

Guides
------

* Student and Teacher introductions

Resources
---------

* title: (optional) but may be identified by resource type
* subtitle and icon from resourceType
* author: (optional. If more than one, make it a yaml list)
* date: (of first publication - maybe this should be automated)
* clearance-flag: 
	Flag 0 as WIP when publishing at level 1
	Flag 4 as WIP when publishing at level 5
* Main station

* Everything should be addressable


Logo
----

A maths train?




