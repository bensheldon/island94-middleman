---
title: Good enough data
date: '2010-02-22'
tags:
- ability
- data
- navigation
- parsing
- portfolio
- yawn
wp:post_id: '1776'
link: http://island94.dev/2010/02/good-enough-data/
wp:post_type: post
files:
- http://www.island94.org/wp-content/uploads/2010/02/btop-map-combined-500x462.png
---

<img class="aligncenter size-medium wp-image-1783" title="btop-map-combined" src="http://www.island94.org/wp-content/uploads/2010/02/btop-map-combined-500x462.png" alt="" width="500" height="462" />

I've been spending some time at work scraping data. Long story short: government transparency is not transparent when the only access they give you is a pile of poorly structured html. That's better than government opacity but not past the level of frosted glass: titillating but unsatisfying. If your expected audience is pencil pushers, please release your data in a spreadsheet. <a href="http://transmissionproject.org/current/2009/11/ntia-broadband-access-data">That's what I did</a>.

Notes for nerds:

<strong>Regular Expressions vs. Parsing Engines: </strong>I wrote a the first parser in Python with Regular Expressions, then rewrote it in BeautifulSoup (a Python parser). It took me about 2 hours to write it the first time with RegExp. It took me about 2 days to do it with BeautifulSoup. It's slightly easier to maintain now, but you tell me which one is more semantically correct:

<code>project_title = re.search('&lt;tr&gt;&lt;td&gt;&lt;b&gt;Project&amp;nbsp;title&lt;/b&gt;&lt;/td&gt;&lt;td&gt;(.+)&lt;/td&gt;&lt;/tr&gt;', line)</code>

versus

<code>project_title = app.find(text="Project&amp;nbsp;title").parent.parent.nextSibling.string</code>

Yep, it's written in 2-column tables with each row being a different data-set: the first column holds a key (if there is a key; sometimes there isn't) and the second column being the data . With RegExp, I know exactly what I'm looking for. With the parser, I have to find the element in the tree, then traverse up, over and down (if there isn't a key, I have to go up, up, over, over, over, down, over, down). The data itself is a big set of applications (about 2000+ total) and each application has about 15 different data-sets (some with keys, some just follow a consistent-ish pattern).

Fortunately, I have an <a href="http://www.media-democracy.net/">appreciative audience</a> for my troubles and it lets me <a href="http://transmissionproject.org/current/2010/2/btop-applications-and-awards-by-state">draw pretty maps</a> like the ones above. Also <a href="http://flowingdata.com/2009/11/12/how-to-make-a-us-county-thematic-map-using-free-tools/">done with Python</a> by parsing an SVG vector image.

<strong>Michigan boaters beware</strong>: there is now an isthmus between Mackinaw City and St. Ignace. Rather than rewrite the process for grouped-shapes---Michigan being in 2 parts---it was good enough to make Michigan 1. Hawaii somehow endured.
