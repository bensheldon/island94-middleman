---
title: Boston's Best Tacos
date: '2007-01-05'
tags:
- community mapping
- food
- map
- tacos
wp:post_id: '115'
link: http://island94.dev/2007/01/bostons-best-tacos/
wp:post_type: post
---

$mymarkers=array(

array('markername'=&gt;'number01',
'label' =&gt; '<strong>Tacos El Charro</strong>
349 Centre St
Jamaica Plain, MA 02130',
'latitude' =&gt;'42.32269914619183',
'longitude'=&gt;'-71.10684156417847'),                 array('markername'=&gt;'number02',
'label' =&gt; '<strong>Tacos Lupita</strong>
13 Elm St
Somerville, MA 02143',
'latitude' =&gt;'42.38600050368276',
'longitude'=&gt;'-71.11351490020752'),
array('markername'=&gt;'number03',
'label' =&gt; '<strong>Takueria Tapatillo</strong>
82 Broadway
Somerville, MA 02145',
'latitude' =&gt;'42.387038609014645',
'longitude'=&gt;'-71.08207941055298'));

$mymap=array('id' =&gt; 'tacomap',
'latitude' =&gt; '42.36031976410849',
'longitude'=&gt;' -71.0757064819336',
'zoom' =&gt; 12,
'width' =&gt; '100%',
'height' =&gt; '400px',
'type' =&gt; 'Hybrid',
'markers' =&gt; $mymarkers);
print gmap_draw_map($mymap);

?&gt;

I miss eating good taqueria food and Boston's inhibited palette is definitely to blame.  I like places that call the tacos by name, Carne Asada, Al Pastor, Lengua--not Beef, Pork , Chicken (Lengua isn't chicken, but your anglo-taqueria isn't going to have it, or call it what it is: <em>beef tongue</em>); where the salsa is more than pico de gallo and you get a slice of radish.  The map above has the few places I've found in Boston that I like.

They are:

<strong>#1) Tacos El Charro</strong>
349 Centre St
Jamaica Plain, MA 02130
<em>Super friendly sit-down restaurant.  Also the enchiladas are great. Go downstairs, it's "authentic"!</em>

<strong>#2) Tacos Lupita</strong>
13 Elm St
Somerville, MA 02143
<em>Close to Porter Square.  The food is delicious and they have imported Coca-Cola made with real sugar, not corn syrup.</em>

<strong>#3) Takueria Tapatillo</strong>
82 Broadway
Somerville, MA 02145
<em>Actually Chilean but excellent taqueria.  They have a good vegetarian taco too.  Was taking an unrelated cab and mentioned the place to my friend.  The cabdriver overheard and said that he went there all the time.  The cabby looks European but is really Brazilian and fluent in Spanish.  He said that when he goes into the taqueria, the staff speak to him in English until he starts belting out Spanish.  They are so impressd his lunch is free.</em>
