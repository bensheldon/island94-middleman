---
title: 'Geekout: Video on Maps for Cable Access TV'
date: '2007-08-02'
tags:
- Cable Access
- coding
- development
- Drupal
- geekout
- navigation
- portfolio
- video
wp:post_type: post
redirects:
- "/2007/08/geekout:-video-on-maps-for-cable-access-tv/"
- "/node/136"
- "/articles/geekout-video-maps-cable-access-tv"
- "/2007/08/geekout-video-on-maps-for-cable-access-tv/"
- "/?p=136"
---

![](2007-08-02-Geekout-Video-on-Maps-for-Cable-Access-TV/mediamap-600x448.jpg "mediamap")

I recently did some [Drupal](http://drupal.org) development work for [Cambridge Community Television](http://cctvcambridge.org). As part of the really amazing work they are doing combining new media with traditional [Cable Access Television](http://alliancecm.org), CCTV has been mapping videos their members produce. They call this project the [Mediamap](http://cctvcambridge.org/mediamap).

I was really excited to work on the Mediamap with CCTV because of my long [involvement](http://island94.org/articles/future-cable-access) with Cable Access Television, most notably the now-defunct [DigitalBicycle Project](http://digitalbicycle.org) and the community maintained directory of Cable Access Stations I built and administer: [MappingAccess.com](http://mappingaccess.com).

Despite CCTV running their website on Drupal, their first proof-of-concept version of the Mediamap was created manually, using the very capable [Mapbuilder.net](http://mapbuilder.net) service and copy-and-pasted embedded flash video. While simple from a technological standpoint, they were running to problems optimizing the workflow of updating the map; changes had to be made via the Mapbuilder.net interface, with a single username and password, then manually parsed to remove some coding irregularities, and finally copy and pasted whole into a page on their website.

I was asked to improve the workflow and ultimately take fuller advantage of Drupal's built-in user management and content management features. For instance, taking advantage of CCTV's current member submitted video capabilities and flowing them into the map as an integrated report, not a separate and parallel system.

In my discussions with them, a couple of issues came up. Foremost was that CCTV was running an older version of Drupal: 4.7. While still quite powerful, many newer features and contributed modules were not available for this earlier release. The current version of Drupal, 5.1, has many rich, well-developed utilities for creating reports and mapping them: [Content Construction Kit (CCK)](http://drupal.org/project/cck) + [Views](http://drupal.org/project/views) + [Gmap](http://drupal.org/project/gmap) + [Location](http://drupal.org/project/location). As it was though, with the older version, I would have to develop the additional functionality manually.

The following is a description, with code examples, of the functionality I created for the Mediamap. Additionally, following this initial development, CCTV upgraded their Drupal installation to 5.1, giving me the opportunity to demonstrate the ease and power of Drupal's most recent release---rendering blissfully obsolete most of the custom coding I had done.

Location and Gmap was used in both versions for storing geographic data and hooking into the Google Map API. One of Drupal's great strengths is the both the diversity of contributed modules, and the flexibility with which a developer can use them.

### Adding additional content fields

CCTV already has a process in which member's can submit content nodes. In 4.7, the easiest way to add additional data fields to these was with a custom [NodeAPI module](http://api.drupal.org/api/file/nodeapi_example.module/4.7). CCTV was interested in using embedded flash video, primarily from [Blip.tv](http://blip.tv), but also Google Video or YouTube if the flexibility was needed. To simplify the process, we decided on just adding the cut-and-paste embed code to a custom content field in existing nodes.

To do this, I created a new module that invoked hook\_nodeapi:

``

/\*\*

\* Implementation of hook\_nodeapi

\*/

function cambridge\_mediamap\_nodeapi(&$node, $op, $teaser, $page) {

switch ($op) {

`case 'validate':`

if (variable\_get('cambridge\_mediamap\_'. $node->type, TRUE)) {

if (user\_access('modify node data')) {

if ($node->cambridge\_mediamap['display'] && $node->cambridge\_mediamap['embed'] == '') {

form\_set\_error('cambridge\_mediamap', t('Media Map: You must enter embed code or disable display of this node on the map'));

}

}

}

break;

``

`case 'load':`

$object = db\_fetch\_object(db\_query('SELECT display, embed FROM {cambridge\_mediamap} WHERE nid = %d', $node->nid));

`$embed = $object->embed;`

$embed\_resize = cambridge\_mediamap\_resize($embed);

return array(

'cambridge\_mediamap' => array(

'display' => $object->display,

'embed' => $embed,

'embed\_resize' => $embed\_resize,

)

);

break;

case 'insert':

db\_query("INSERT INTO {cambridge\_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node->nid, $node->cambridge\_mediamap['display'], $node->cambridge\_mediamap['embed']);

break;

case 'update':

db\_query('DELETE FROM {cambridge\_mediamap} WHERE nid = %d', $node->nid);

db\_query("INSERT INTO {cambridge\_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node->nid, $node->cambridge\_mediamap['display'], $node->cambridge\_mediamap['embed']);

break;

case 'delete':

db\_query('DELETE FROM {cambridge\_mediamap} WHERE nid = %d', $node->nid);

break;

 

 

`case 'view':`

break;

}

}

As you can see, there is a considerable amount of coding required, from defining the form, validating input and configuring database storage and retrieval calls.

Now that we have the glue for the custom field, we have to configure what node types that custom field appears on. Additionally, we need to set up administrative settings to configure where that custom field will appear, and lastly insert that field into the node edit screen:

``

/\*\*

\* Implementation of hook\_form\_alter

\*/

function cambridge\_mediamap\_form\_alter($form\_id, &$form) {

// We're only modifying node forms, if the type field isn't set we don't need

// to bother.

if (!isset($form['type'])) {

return;

}

`//disable the Gmap module's location map for unauthorized users`

//unfortunately Gmap.module doesn't have this setting

if (isset($form['coordinates'])) {

if (!user\_access('modify node data')) {

unset($form['coordinates']);

}

}

``

`// Make a copy of the type to shorten up the code`

$type = $form['type']['#value'];

`// Is the map enabled for this content type?`

$enabled = variable\_get('cambridge\_mediamap\_'. $type, 0);

switch ($form\_id) {

// We need to have a way for administrators to indicate which content

// types should have the additional media map information added.

case $type .'\_node\_settings':

$form['workflow']['cambridge\_mediamap\_'. $type] = array(

'#type' => 'radios',

'#title' => t('Cambridge Mediamap setting'),

'#default\_value' => $enabled,

'#options' => array(0 => t('Disabled'), 1 => t('Enabled')),

'#description' => t('Allow the attaching of externally hosted imbedded video to be displayed in a map?'),

);

break;

case $type .'\_node\_form':

if ($enabled && user\_access('modify node data')) {

//create the fieldset

$form['cambridge\_mediamap'] = array(

'#type' => 'fieldset',

'#title' => t('Media Map'),

'#collapsible' => TRUE,

'#collapsed' => FALSE,

'#tree' => TRUE,

);

//insert the embed code

$form['cambridge\_mediamap']['embed'] = array(

'#type' => 'textarea',

'#title' => t('Video Embed Code'),

'#default\_value' => $form['#node']->cambridge\_mediamap['embed'],

'#cols' => 60,

'#rows' => 5,

'#description' => t('Copy and paste the embed code from an external video or media hosting service'),

);

//enable or disable on map

$form['cambridge\_mediamap']['display'] = array(

'#type' => 'select',

'#title' => t('Display this node'),

'#default\_value' => $form['#node']->cambridge\_mediamap['display'],

'#options' => array(

'0' => t('Disable display'),

'1' => t('Enable display'),

),

);

 

 

`}`

break;

}

}

As you can see, that's a lot of lines of code for what we essentially can do, in Drupal 5.1 with CCK. CCK allows you, graphically through the Drupal web-interface, to create a new content field and add it to a node type; it takes about a minute.

### Building the Map

The primary goal of rebuilding the Mediamap using native Drupal was workflow optimization: it was frustrating to submit information both within Drupal and then recreate it within Mapbuilder. In essence, the map should be just another report of Drupal content: you may have a short bulleted list of the top five articles, a paginated history with teasers and author information, or a full-blown map, but most importantly, all of it is flowing dynamically out of the Drupal database.

The Gmap module provides many powerful ways to integrate the Google Map API with Drupal. While Gmap for 4.7 provides a default map of content it would not provide the features or customizability we desired with the Mediamap. Instead, one of the most powerful ways to use Gmap is to hook directly into the module's own API-like functions:

``

/\*\*

\* A page callback to draw the map

\*/

function cambridge\_mediamap\_map() {

$output = '';

`//Collect the nodes to be displayed`

$results = db\_query('SELECT embed, nid FROM {cambridge\_mediamap} WHERE display = 1');

``

`//Initialize our marker array`

$markers = array();

`//check to see what modules are enabled`

$location\_enabled = module\_exist('location');

$gmap\_location\_enabled = module\_exist('gmap\_location');

//load each node and set it's attributes in the marker array

while($item = db\_fetch\_object($results)) {

$latitude = 0;

$longitude = 0;

//load the node

$node = node\_load(array('nid' => $item->nid));

//set the latitude and longitude

//give location module data preference over gmap module data

if ($location\_enabled) {

$latitude = $node->location['latitude'];

$longitude = $node->location['longitude'];

}

elseif ($gmap\_location\_enabled) {

$latitude = $node->gmap\_location\_latitude;

$longitude = $node->gmap\_location\_longitude;

}

if ($latitude && $longitude) {

$markers[] = array(

'label' => theme('cambridge\_mediamap\_marker', $node),

'latitude' => $latitude,

'longitude' => $longitude,

'markername' => variable\_get('cambridge\_mediamap\_default\_marker', 'marker'),

);

}

}

$latlon = explode(',', variable\_get('cambridge\_mediamap\_default\_latlong','42.369452,-71.100426'));

$map=array(

'id' => 'cambridge\_mediamap',

'latitude' => trim($latlon[0]),

'longitude'=> trim($latlon[1]),

'width' => variable\_get('cambridge\_mediamap\_default\_width','100%'),

'height' => variable\_get('cambridge\_mediamap\_default\_height','500px'),

'zoom' => variable\_get('cambridge\_mediamap\_default\_zoom', 13),

'control' => variable\_get('cambridge\_mediamap\_default\_control','Large'),

'type' => variable\_get('cambridge\_mediamap\_default\_type','Satellite'),

'markers' => $markers,

);

 

 

`return gmap_draw_map($map);`

}

As you can see, this is quite complicated. Drupal 5.1 offers the powerful Views module, which allows one to define custom reports, once again graphically from the Drupal web-interface, in just a couple minutes of configuration. The gmap\_views module, which ships with Gmap, allows one to add those custom reports to a Google Map, which is incredibly useful and renders obsolete much of the development work I did.

### On displaying video in maps

In my discussions with CCTV, we felt it most pragmatic to use the embedded video code provided by video hosting services such as Blip.tv. While we could have used one of the Drupal video modules, we wanted the ability to host video offsite due to storage constraints. While I was concerned about the danger of code injection via minimally validated inputs, we felt that this would be of small danger because the content would be maintained by CCTV staff and select members.

The markers were themed using the embedded video field pulled from the Drupal database, along with the title and a snippet of the description, all linking back to the full content node.

    /**

\* A theme function for our markers

\*/

function theme\_cambridge\_mediamap\_marker($node) {

$output = '

';

$output .= '

' . l($node->title, 'node/' . $node->nid) . '

';

$output .= '

' . $node->cambridge\_mediamap['embed\_resize'] . '

';

$output .= '

';

return $output;

}

With Drupal 5.1 and Views, we still had to override the standard marker themes, but this was simple and done through the standard methods.

One of the most helpful pieces was some code developed by [Rebecca White](http://circuitous.org), who I previously worked with on [Panlexicon](http://panlexicon.com). She provided the critical pieces of code that parsed the embedded video code and resized it for display on small marker windows.

    /**

\* Returns a resized embed code

\*/

function cambridge\_mediamap\_resize($embed = '') {

if (!$embed) {

return '';

}

list($width, $height) = cambridge\_mediamap\_get\_embed\_size($embed);

//width/height ratio

$width\_to\_height = $width / $height;

$max\_width = variable\_get('cambridge\_mediamap\_embed\_width','320');

$max\_height = variable\_get('cambridge\_mediamap\_embed\_height','240');

//shrink down widths while maintaining proportion

if ($width >= $height) {

if ($width > $max\_width) {

$width = $max\_width;

$height = (1 / $width\_to\_height) \* $width;

}

if ($height > $max\_height) {

$height = $max\_height;

$width = ($width\_to\_height) \* $height;

}

}

else {

if ($height > $max\_height) {

$height = $max\_height;

$width = ($width\_to\_height) \* $height;

}

if ($width > $max\_width) {

$width = $max\_width;

$height = (1 / $width\_to\_height) \* $width;

}

}

return cambridge\_mediamap\_set\_embed\_size($embed, intval($width), intval($height));

}

/\*\*

\* find out what size the embedded thing is

\*/

function cambridge\_mediamap\_get\_embed\_size($html) {

preg\_match('/]\*width(\s\*=\s\*"|:\s\*)(\d+)/i', $html, $match\_width);

preg\_match('/]\*height(\s\*=\s\*"|:\s\*)(\d+)/i', $html, $match\_height);

return array($match\_width[2], $match\_height[2]);

}

/\*\*

\* set the size of the embeded thing

\*/

function cambridge\_mediamap\_set\_embed\_size($html, $width, $height) {

$html = preg\_replace('/(<(embed|object)\s[^>]\*width(\s\*=\s\*"|:\s\*))(\d+)/i', '${1}' . $width, $html);

$html = preg\_replace('/(<(embed|object)\s[^>]\*height(\s\*=\s\*"|:\s\*))(\d+)/i', '${1}' . $height, $html);

return $html;

}

/\*\*

\* returns the base url of the src attribute.

\* youtube = www.youtube.com

\* blip = blip.tv

\* google video = video.google.com

\*/

function cambridge\_mediamap\_get\_embed\_source($html) {

preg\_match('/]\*src="http:\/\/([^\/"]+)/i', $html, $match\_src);

return $match\_src[1];

}

### The Wrap-Up

While it may not seem so from the lines of code above, developing for Drupal is still relatively easy. Drupal provides a rich set of features for developers, [well documented features](http://api.drupal.org), and strong [coding standards](http://drupal.org/coding-standards)---making reading other people's code and learning from it incredibly productive.

Below is the entirety of the custom module I developed for the 4.7 version of the CCTV Media Map. Because it was custom and intended to be used in-house, many important, release worthy functions were omitted, such as richer administrative options and module/function verifications.

    'cambridge_mediamap',

'title' => t('Mediamap'),

'callback' => 'cambridge\_mediamap\_map',

'access' => user\_access('access mediamap'),

);

}

return $items;

}

/\*\*

\* Implementation of hook\_nodeapi

\*/

function cambridge\_mediamap\_nodeapi(&$node, $op, $teaser, $page) {

switch ($op) {

case 'validate':

if (variable\_get('cambridge\_mediamap\_'. $node->type, TRUE)) {

if (user\_access('modify node data')) {

if ($node->cambridge\_mediamap['display'] && $node->cambridge\_mediamap['embed'] == '') {

form\_set\_error('cambridge\_mediamap', t('Media Map: You must enter embed code or disable display of this node on the map'));

}

}

}

break;

case 'load':

$object = db\_fetch\_object(db\_query('SELECT display, embed FROM {cambridge\_mediamap} WHERE nid = %d', $node->nid));

$embed = $object->embed;

$embed\_resize = cambridge\_mediamap\_resize($embed);

return array(

'cambridge\_mediamap' => array(

'display' => $object->display,

'embed' => $embed,

'embed\_resize' => $embed\_resize,

)

);

break;

case 'insert':

db\_query("INSERT INTO {cambridge\_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node->nid, $node->cambridge\_mediamap['display'], $node->cambridge\_mediamap['embed']);

break;

case 'update':

db\_query('DELETE FROM {cambridge\_mediamap} WHERE nid = %d', $node->nid);

db\_query("INSERT INTO {cambridge\_mediamap} (nid, display, embed) VALUES (%d, %d, '%s')", $node->nid, $node->cambridge\_mediamap['display'], $node->cambridge\_mediamap['embed']);

break;

case 'delete':

db\_query('DELETE FROM {cambridge\_mediamap} WHERE nid = %d', $node->nid);

break;

case 'view':

break;

}

}

/\*\*

\* Returns a resized embed code

\*/

function cambridge\_mediamap\_resize($embed = '') {

if (!$embed) {

return '';

}

list($width, $height) = cambridge\_mediamap\_get\_embed\_size($embed);

//width/height ratio

$width\_to\_height = $width / $height;

$max\_width = variable\_get('cambridge\_mediamap\_embed\_width','320');

$max\_height = variable\_get('cambridge\_mediamap\_embed\_height','240');

//shrink down widths while maintaining proportion

if ($width >= $height) {

if ($width > $max\_width) {

$width = $max\_width;

$height = (1 / $width\_to\_height) \* $width;

}

if ($height > $max\_height) {

$height = $max\_height;

$width = ($width\_to\_height) \* $height;

}

}

else {

if ($height > $max\_height) {

$height = $max\_height;

$width = ($width\_to\_height) \* $height;

}

if ($width > $max\_width) {

$width = $max\_width;

$height = (1 / $width\_to\_height) \* $width;

}

}

return cambridge\_mediamap\_set\_embed\_size($embed, intval($width), intval($height));

}

/\*\*

\* find out what size the embedded thing is

\*/

function cambridge\_mediamap\_get\_embed\_size($html) {

preg\_match('/]\*width(\s\*=\s\*"|:\s\*)(\d+)/i', $html, $match\_width);

preg\_match('/]\*height(\s\*=\s\*"|:\s\*)(\d+)/i', $html, $match\_height);

return array($match\_width[2], $match\_height[2]);

}

/\*\*

\* set the size of the embeded thing

\*/

function cambridge\_mediamap\_set\_embed\_size($html, $width, $height) {

$html = preg\_replace('/(<(embed|object)\s[^>]\*width(\s\*=\s\*"|:\s\*))(\d+)/i', '${1}' . $width, $html);

$html = preg\_replace('/(<(embed|object)\s[^>]\*height(\s\*=\s\*"|:\s\*))(\d+)/i', '${1}' . $height, $html);

return $html;

}

/\*\*

\* returns the base url of the src attribute.

\* youtube = www.youtube.com

\* blip = blip.tv

\* google video = video.google.com

\*/

function cambridge\_mediamap\_get\_embed\_source($html) {

preg\_match('/]\*src="http:\/\/([^\/"]+)/i', $html, $match\_src);

return $match\_src[1];

}

/\*\*

\* Implementation of hook\_form\_alter

\*/

function cambridge\_mediamap\_form\_alter($form\_id, &$form) {

// We're only modifying node forms, if the type field isn't set we don't need

// to bother.

if (!isset($form['type'])) {

return;

}

//disable the Gmap module's location map for unauthorized users

//unfortunately Gmap.module doesn't have this setting

if (isset($form['coordinates'])) {

if (!user\_access('modify node data')) {

unset($form['coordinates']);

}

}

// Make a copy of the type to shorten up the code

$type = $form['type']['#value'];

// Is the map enabled for this content type?

$enabled = variable\_get('cambridge\_mediamap\_'. $type, 0);

switch ($form\_id) {

// We need to have a way for administrators to indicate which content

// types should have the additional media map information added.

case $type .'\_node\_settings':

$form['workflow']['cambridge\_mediamap\_'. $type] = array(

'#type' => 'radios',

'#title' => t('Cambridge Mediamap setting'),

'#default\_value' => $enabled,

'#options' => array(0 => t('Disabled'), 1 => t('Enabled')),

'#description' => t('Allow the attaching of externally hosted imbedded video to be displayed in a map?'),

);

break;

case $type .'\_node\_form':

if ($enabled && user\_access('modify node data')) {

//create the fieldset

$form['cambridge\_mediamap'] = array(

'#type' => 'fieldset',

'#title' => t('Media Map'),

'#collapsible' => TRUE,

'#collapsed' => FALSE,

'#tree' => TRUE,

);

//insert the embed code

$form['cambridge\_mediamap']['embed'] = array(

'#type' => 'textarea',

'#title' => t('Video Embed Code'),

'#default\_value' => $form['#node']->cambridge\_mediamap['embed'],

'#cols' => 60,

'#rows' => 5,

'#description' => t('Copy and paste the embed code from an external video or media hosting service'),

);

//enable or disable on map

$form['cambridge\_mediamap']['display'] = array(

'#type' => 'select',

'#title' => t('Display this node'),

'#default\_value' => $form['#node']->cambridge\_mediamap['display'],

'#options' => array(

'0' => t('Disable display'),

'1' => t('Enable display'),

),

);

}

break;

}

}

/\*\*

\* A page callback to draw the map

\*/

function cambridge\_mediamap\_map() {

$output = '';

//Collect the nodes to be displayed

$results = db\_query('SELECT embed, nid FROM {cambridge\_mediamap} WHERE display = 1');

//Initialize our marker array

$markers = array();

//check to see what modules are enabled

$location\_enabled = module\_exist('location');

$gmap\_location\_enabled = module\_exist('gmap\_location');

//load each node and set it's attributes in the marker array

while($item = db\_fetch\_object($results)) {

$latitude = 0;

$longitude = 0;

//load the node

$node = node\_load(array('nid' => $item->nid));

//set the latitude and longitude

//give location module data preference over gmap module data

if ($location\_enabled) {

$latitude = $node->location['latitude'];

$longitude = $node->location['longitude'];

}

elseif ($gmap\_location\_enabled) {

$latitude = $node->gmap\_location\_latitude;

$longitude = $node->gmap\_location\_longitude;

}

if ($latitude && $longitude) {

$markers[] = array(

'label' => theme('cambridge\_mediamap\_marker', $node),

'latitude' => $latitude,

'longitude' => $longitude,

'markername' => variable\_get('cambridge\_mediamap\_default\_marker', 'marker'),

);

}

}

$latlon = explode(',', variable\_get('cambridge\_mediamap\_default\_latlong','42.369452,-71.100426'));

$map=array(

'id' => 'cambridge\_mediamap',

'latitude' => trim($latlon[0]),

'longitude'=> trim($latlon[1]),

'width' => variable\_get('cambridge\_mediamap\_default\_width','100%'),

'height' => variable\_get('cambridge\_mediamap\_default\_height','500px'),

'zoom' => variable\_get('cambridge\_mediamap\_default\_zoom', 13),

'control' => variable\_get('cambridge\_mediamap\_default\_control','Large'),

'type' => variable\_get('cambridge\_mediamap\_default\_type','Satellite'),

'markers' => $markers,

);

return gmap\_draw\_map($map);

}

/\*\*

\* A theme function for our markers

\*/

function theme\_cambridge\_mediamap\_marker($node) {

$output = '

';

$output .= '

' . l($node->title, 'node/' . $node->nid) . '

';

$output .= '

' . $node->cambridge\_mediamap['embed\_resize'] . '

';

$output .= '

';

return $output;

}

/\*\*

\* Settings page

\*/

function cambridge\_mediamap\_settings() {

// Cambridge data

// latitude = 42.369452

// longitude = -71.100426

$form['defaults']=array(

'#type' => 'fieldset',

'#title' => t('Default map settings'),

);

$form['defaults']['cambridge\_mediamap\_default\_width'] = array(

'#type' => 'textfield',

'#title' => t('Default width'),

'#default\_value' => variable\_get('cambridge\_mediamap\_default\_width','100%'),

'#size' => 25,

'#maxlength' => 6,

'#description' => t('The default width of a Google map. Either px or %'),

);

$form['defaults']['cambridge\_mediamap\_default\_height'] = array(

'#type' => 'textfield',

'#title' => t('Default height'),

'#default\_value' => variable\_get('cambridge\_mediamap\_default\_height','500px'),

'#size' => 25,

'#maxlength' => 6,

'#description' => t('The default height of Mediamap. In px.'),

);

$form['defaults']['cambridge\_mediamap\_default\_latlong'] = array(

'#type' => 'textfield',

'#title' => t('Default center'),

'#default\_value' => variable\_get('cambridge\_mediamap\_default\_latlong','42.369452,-71.100426'),

'#description' => 'The decimal latitude,longitude of the centre of the map. The "." is used for decimal, and "," is used to separate latitude and longitude.',

'#size' => 50,

'#maxlength' => 255,

'#description' => t('The default longitude, latitude of Mediamap.'),

);

$form['defaults']['cambridge\_mediamap\_default\_zoom']=array(

'#type'=>'select',

'#title'=>t('Default zoom'),

'#default\_value'=>variable\_get('cambridge\_mediamap\_default\_zoom', 13),

'#options' => drupal\_map\_assoc(range(0, 17)),

'#description'=>t('The default zoom level of Mediamap.'),

);

$form['defaults']['cambridge\_mediamap\_default\_control']=array(

'#type'=>'select',

'#title'=>t('Default control type'),

'#default\_value'=>variable\_get('cambridge\_mediamap\_default\_control','Large'),

'#options'=>array('None'=>t('None'),'Small'=>t('Small'),'Large'=>t('Large')),

);

$form['defaults']['cambridge\_mediamap\_default\_type']=array(

'#type'=>'select',

'#title'=>t('Default map type'),

'#default\_value'=>variable\_get('cambridge\_mediamap\_default\_type','Satellite'),

'#options'=>array('Map'=>t('Map'),'Satellite'=>t('Satellite'),'Hybrid'=>t('Hybrid')),

);

$markers = gmap\_get\_markers();

$form['defaults']['cambridge\_mediamap\_default\_marker'] = array(

'#type'=>'select',

'#title'=>t('Marker'),

'#default\_value'=>variable\_get('cambridge\_mediamap\_default\_marker', 'marker'),

'#options'=>$markers,

);

$form['embed']=array(

'#type' => 'fieldset',

'#title' => t('Default embedded video settings'),

);

$form['embed']['cambridge\_mediamap\_embed\_width'] = array(

'#type' => 'textfield',

'#title' => t('Default width'),

'#default\_value' => variable\_get('cambridge\_mediamap\_embed\_width','320'),

'#size' => 25,

'#maxlength' => 6,

'#description' => t('The maximum width of embedded video'),

);

$form['embed']['cambridge\_mediamap\_embed\_height'] = array(

'#type' => 'textfield',

'#title' => t('Default height'),

'#default\_value' => variable\_get('cambridge\_mediamap\_embed\_height','240'),

'#size' => 25,

'#maxlength' => 6,

'#description' => t('The maximum height of embedded video.'),

);

return $form;

}

/\*\*

\* Prints human-readable (html) information about a variable.

\* Use: print debug($variable\_name);

\* Or assign output to a variable.

\*/

function debug($value) {

return preg\_replace("/\s/", " ", preg\_replace("/\n/", "",

print\_r($value, true)));

}
