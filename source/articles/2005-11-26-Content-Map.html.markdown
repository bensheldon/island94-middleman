---
title: Content Map
date: '2005-11-26'
tags: []
wp:post_id: '15'
link: http://island94.dev/2005/11/content-map/
wp:post_type: post
---

<p><!--break--></p>
<p>This is an example of my googlemap module that I extended from <a href="http://drupal.org/node/29091">this module</a> by <a href="http://choirgeek.com/">bjornarneson</a>.</p>
<p>It creates map points through parsing local <span class="caps">RSS</span> feeds that Drupal produces.  Normally these feeds only contain the last 15 posts, but I hacked together a helper module (fullfeed.module) that uses taxonomy.module urls (with cool term parsing) but adds <em>all</em> content in the term (or terms) to the feed.</p>
<p>With each feed I can define a custom marker (.png files  I created and uploaded).  The markers are all default size and shadow&#8212;this is limiting, but it&#8217;s a <acronym title="Pain In The Ass"><span class="caps">PITA</span></acronym> to modify it.</p>
<p>The workflow for this is relatively easy.  Pure latitude and longitude data is inputed via location.module&#8212;I grab it from maps.google.com because I couldn&#8217;t get the geocoding from an address to work, though many of my nodes are from random places and this is much more accurate.  I have a vocabulary setup just for mapped nodes (photos, videos, random thoughts, etc), and use these as my feeds.  Custom icons I created and FTPed in, though you could just use upload.module and attach them to your map node.</p>
<p><del>It currently does not support lines, though I am definitely planning on adding them. but I don&#8217;t have a good idea of workflow though, considering there is not a standard <span class="caps">RSS</span> element and am not sure if it&#8217;s going to be too hard to either&#8230;</del></p>
<p><ins>The module now supports lines as a nodeapi hook (like location.module adds lat/long).  Each feed can set a custom line color.  I don&#8217;t know workflow yet whether to keep it like this, or have color on a per-node basis.</ins></p>
<p><ins>There is still the line issue of:</ins></p>
<ul>
	<li>define a new namespace (I have no clue on how to do this)</li>
	<li>coopt an existing but unused element and pray we don&#8217;t break anything</li>
	<li><del>parse a static xml file that would somehow be specified in a node</del></li>
</ul>
<p>Lastly, there is an issue with posting more than one map on a page (it breaks).  This is because every map sets things in the header, and I&#8217;m not sure what is the best way to make sure that they only post the important stuff <em>once</em> when there is a list of them.</p>