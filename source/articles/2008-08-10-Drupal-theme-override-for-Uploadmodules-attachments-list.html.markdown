---
title: 'Drupal: theme override for Upload.module''s attachments list'
date: '2008-08-10'
tags:
- art
- design
- Drupal
- intuitive
- navigation
- portfolio
- snippet
- webdesign
wp:post_id: '238'
link: http://island94.dev/2008/08/drupal-theme-override-for-upload-modules-attachments-list/
wp:post_type: post
files:
- http://island94.org/files/island94.org/shiny_upload-example.png
- http://island94.org/files/island94.org/shiny_upload.zip
---

<strong>Update:</strong> this functionality can now be achieved with the <a href="http://drupal.org/project/itweak_upload">iTweak_upload module </a>. <em>Thanks to <a href="http://damoncook.net/">Damon</a> for the tip!</em>

I made a custom override for Drupal 6.x's Upload.module's attachments table that is displayed at the bottom of a node when you create file attachments.  That table is, in my opinion, one of the ugliest common and default presentations in Drupal core. Below is an example of the before and after:

<img src="http://island94.org/files/island94.org/shiny_upload-example.png" alt="Example of override" />

&nbsp;
<div style="display: none;"><a href="http://www.chainreaction-community.net/?hocus_pocus">Hocus Pocus hd</a></div>
To use it, unzip and drop the included folder into your active theme's directory (e.g. /sites/default/all/garland), it should take effect without any other modifications---though you may have to reset the theme cache (goto admin/build/themes and click save without making any other changes).

<a href="http://island94.org/files/island94.org/shiny_upload.zip">Click Here to Download (shiny_upload.zip)</a>

&nbsp;
<div style="display: none;"><a href="http://www.womeningreen.org/?return_to_never_land">Return to Never Land movie</a></div>
Also, I don't know what the name is for these types of theme overrides: it's not a module, and it's not a whole theme.  I <a href="http://groups.drupal.org/node/13873">posted this</a> to a Drupal Group that, I think, calls them "<a href="http://groups.drupal.org/themer-pack-working-group">Themer Packs</a>".

The icon code is based on the CCK <a href="http://drupal.org/project/filefield">filefield module</a>---but the current 6.0 version is kind've clunky and I wanted to port it to the core Upload module.  The namespace is "shiny_upload".

Also, as an aside, the reason island94.org doesn't currently have this enabled is because it's still running on Drupal 5.x branch
