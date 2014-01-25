---
title: Adding class to Wordpress linked images
date: '2011-01-23'
tags:
- code
- css
- php
- theming
- wordpress
wp:post_id: '2425'
wp_link: "/2011/01/adding-class-to-wordpress-linked-images/"
wp:post_type: post
---

An [enduring issue](http://wordpress.org/support/topic/how-can-i-set-the-class-of-anchors) with linked images ( `<a href=""><img src="" /></a>` ), is targeting the anchor link for theming—especially for disabling borders and highlighting that look great on text links but odd for images. CSS doesn't have a parent selector ( `a > img:parent` ), and javascript feels like overkill. The simple solution is to add a `class` to the parent anchor (< `a href="" class="img">)` , but that can get repetitive, especially when Wordpress is supposed to automate those sorts of things.

Adding the following code to your Wordpress theme's `functions.php` file will automatically add a class to the anchor link when you insert linked images through Wordpress's Media Library interface. It won't fix posts you've already written, but should make things better moving forward.



/\*\*

\* Attach a class to linked images' parent anchors

\* e.g. a img => a.img img

\*/

function give\_linked\_images\_class($html, $id, $caption, $title, $align, $url, $size, $alt = '' ){

$classes = 'img'; // separated by spaces, e.g. 'img image-link'

// check if there are already classes assigned to the anchor

if ( preg\_match('/<a.\*? class=".\*?">/', $html) ) {

$html = preg\_replace('/(<a.\*? class=".\*?)(".\*?>)/', '$1 ' . $classes . '$2', $html);

} else {

$html = preg\_replace('/(<a.\*?)>/', '$1 class="' . $classes . '" >', $html);

}

return $html;

}

add\_filter('image\_send\_to\_editor','give\_linked\_images\_class',10,8);

The if/else could probably be done with a single regular expression, but I'm not _that_ smart.
