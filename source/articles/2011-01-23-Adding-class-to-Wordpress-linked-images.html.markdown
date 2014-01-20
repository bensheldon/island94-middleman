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
link: http://island94.dev/2011/01/adding-class-to-wordpress-linked-images/
wp:post_type: post
---

An <a href="http://wordpress.org/support/topic/how-can-i-set-the-class-of-anchors">enduring issue</a> with linked images (<code>&lt;a href=""&gt;&lt;img src="" /&gt;&lt;/a&gt;</code>), is targeting the anchor link for theming—especially for disabling borders and highlighting that look great on text links but odd for images. CSS doesn't have a parent selector ( <span style="text-decoration: line-through;"><code>a &gt; img:parent</code></span>), and javascript feels like overkill. The simple solution is to add a <code>class</code> to the parent anchor (&lt;<code>a href="" class="img"&gt;)</code>, but that can get repetitive, especially when Wordpress is supposed to automate those sorts of things.

Adding the following code to your Wordpress theme's <code>functions.php</code> file will automatically add a class to the anchor link when you insert linked images through Wordpress's Media Library interface. It won't fix posts you've already written, but should make things better moving forward.

<pre><code> 
/**
 * Attach a class to linked images' parent anchors
 * e.g. a img =&gt; a.img img
 */
function give_linked_images_class($html, $id, $caption, $title, $align, $url, $size, $alt = '' ){
  $classes = 'img'; // separated by spaces, e.g. 'img image-link'

  // check if there are already classes assigned to the anchor
  if ( preg_match('/&lt;a.*? class=".*?"&gt;/', $html) ) {
    $html = preg_replace('/(&lt;a.*? class=".*?)(".*?&gt;)/', '$1 ' . $classes . '$2', $html);
  } else {
    $html = preg_replace('/(&lt;a.*?)&gt;/', '$1 class="' . $classes . '" &gt;', $html);
  }
  return $html;
}
add_filter('image_send_to_editor','give_linked_images_class',10,8);
</code></pre>

The if/else could probably be done with a single regular expression, but I'm not <em>that</em> smart.
