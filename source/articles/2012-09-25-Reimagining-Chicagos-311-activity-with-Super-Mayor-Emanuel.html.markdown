---
title: Reimagining Chicago's 311 activity with Super Mayor Emanuel
date: '2012-09-25'
tags:
- analytics
- data
- open311
- portfolio
wp:post_id: '3057'
link: http://island94.dev/2012/09/reimagining-chicagos-311-activity-with-super-mayor-emanuel/
wp:post_type: post
---

<img class="aligncenter size-medium wp-image-3059" title="screenshot" src="http://www.island94.org/wp-content/uploads/2012/11/screenshot-600x437.png" alt="" width="600" height="437" />

<a href="http://supermayor.io">Super Mayor Emanuel</a> is one of the goofier applications I've built at Code for America: <a href="http://supermayor.io"><strong>supermayor.io</strong></a>

<strong>Boring explanation:</strong> Using data from Chicago's Open311 API the app lists, in near-realtime, service requests within the City of Chicago's 311 system that have recently been created, updated or closed.

<strong>Awesome explanation:</strong> The mayor runs through the streets of Chicago, leaping over newly-reported civic issues and collecting coins as those civic problems are fixed.

I really like this application, not only because of its visual style, but because it lets you engage with the 311 data in a completely novel way: aurally. Turn up those speakers and let the website run in the background for about 30 minutes. Spinies (new requests) come in waves, and coin blocks (updated/closed requests) are disappointingly rare. Sure, I could have just created a chart of statistics, but I think actually <em>experiencing</em> requests as they come in makes you think differently about both the people who submitted a request and the 311 operators and city staff who are receiving them (just think about what caused those restaurant complaints... or maybe don't).

The application is built with Node.js, which fetches and caches 311 requests, and a Backbone-based web-app, communicating via socket.io, which manages all of interface and animation. The source is on <a href="https://github.com/codeforamerica/super-mayor">Github</a>.

&nbsp;
