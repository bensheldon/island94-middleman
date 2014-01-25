---
title: 'Drupal: Adding a geocoding failure message to Location Module'
date: '2009-08-13'
tags:
- Drupal
- location
- mapping
- maps
- navigation
- portfolio
- stupid
- warning
wp:post_id: '676'
link: http://island94.dev/2009/08/drupal-adding-a-geocoding-failure-message/
wp:post_type: post
files:
- http://www.island94.org/wp-content/uploads/2009/08/Picture-3-500x136.png
- http://www.island94.org/wp-content/uploads/2009/08/geocode_warn.zip
---

One of the coolest pieces of Drupal is how simple it is to quickly enter a street address and have it show up on a dynamic map on your website using <a href="http://drupal.org/project/location">Location</a> and <a href="http://drupal.org/project/gmap">GMap</a> modules. To make it happen, a lot of stuff goes on behind the scenes. Unfortunately, in typical Drupal fashion, when something goes wrong, you aren't provided much information to fix it.

A big issue if you're having regular users enter information into your website is <em>malformed</em> addresses that can't be automatically converted into latitude/longitude coordinates (geocoding) for display on a map. Out of the box, the Location module doesn't give you a warning if it's unable to geocode an address. On my website <a href="http://mappingaccess.org">MappingAccess.org</a>--a community maintained directory of Cable Access Television stations---I average about an email a week from a visitor saying "I added my station but it's not showing up on the map". Usually it's a simple matter of using a PO Box or wacky abbreviation, but the website itself should be telling them there is a problem, not me.

So I whipped up a simple module that checks everytime a new station is submitted to see if the address was properly geocoded. If not, it displays a message with some tips on how to correct the issue.

<img class="aligncenter size-medium wp-image-679" title="Geocode Warning Message" src="http://www.island94.org/wp-content/uploads/2009/08/Picture-3-500x136.png" alt="Geocode Warning Message" width="500" height="136" />

You can download the module for Drupal 6.x by <a href="http://www.island94.org/wp-content/uploads/2009/08/geocode_warn.zip"><strong>clicking here</strong></a><strong>.</strong>

To be nitpicky, I'd rather the message show up during the validation stage---before the node is submitted---with the option to say "Please edit the address or press submit again to publish with the understanding that it will not show up on the map."  Unfortunately, in Drupal 6 you <a href="http://drupal.org/node/241364">can't make changes to node form during the validation stage</a>---which I would use to set a flag in a hidden form element so that the validation message only gets triggered once. The current implementation calls a drupal_set_message in hook_nodeapi's insert/update operations. It can be enabled on a per-content-type basis (on the Content Type Configuration screen).
