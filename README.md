CKAN Tracker
============

Creating a series of scraping-like routines to generate some basic analytics to a CKAN instance.


Usage
-----

The simpliest way to make the script run is to copy and paste the `scraper.R` script into ScraperWiki's 'Code in a Browser' tool. That option will allow you to use the current tools provided by ScraperWiki to visualize your data.

The only parameter you have to specify is the CKAN instance you are going to be fetching data from:

`ckan_instance <- 'http://data.hdx.rwlabs.org/api/action/'`

The resulting collection should look like this:


More Advanced Usage
-------------------

Use `swbox`.



Known Issues
------------

ScraperWiki currently runs by default R version 2.15. That version of R has many limitations, especially when handling dates and alike. So the dates column has dates as character, which may makes think a little tricky when analyzing it in ScraperWiki's platform so I am transforming them to factors (not the most elegant solution, but it works).


TODO
----
1. Create plotting script and integrate it as a new `tool` within ScraperWiki.