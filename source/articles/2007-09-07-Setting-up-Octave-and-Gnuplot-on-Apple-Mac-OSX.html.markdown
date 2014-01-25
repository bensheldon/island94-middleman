---
title: Setting up Octave and Gnuplot on Apple Mac OSX
date: '2007-09-07'
tags:
- computations
- geeking
- osx
wp:post_id: '151'
link: http://island94.dev/2007/09/setting-up-octave-and-gnuplot-on-osx/
wp:post_type: post
files:
- http://sourceforge.net/projects/octave/files/Octave%2520MacOSX%2520Binary/2009-10-03%2520binary%2520of%2520Octave%25203.2.3/
- http://sourceforge.net/projects/octave/files//Octave%2520MacOSX%2520Binary/2009-10-03%2520binary%2520of%2520Octave%25203.2.3/README_OSX1065.txt/view
---

I just started auditing a Mathematical Models in Biology class and Matlab is one of the requirements.  I had relatively good experience with the free, open source alternative,<a href="http://www.gnu.org/software/octave/">Octave</a> back in college, but then I was running Linux, not OSX.  It took me about an hour to figure out how to set it up (I was a little worried for a bit).
<ol>
	<li>Download the Octave binary for OSX from <a href="http://sourceforge.net/projects/octave/files/Octave%20MacOSX%20Binary/2009-10-03%20binary%20of%20Octave%203.2.3/">Octaveforge</a>.</li>
	<li>Install Octave and Gnuplot (in the extras folder).  I just dragged them to /Applications (X11 is required for Gnuplot---should be found on OSX install disk)</li>
<li>If you are using OSX 10.6 (Snow Leopard) or 10.5.8+ you may need to perform some additional steps <a href="http://sourceforge.net/projects/octave/files//Octave%20MacOSX%20Binary/2009-10-03%20binary%20of%20Octave%203.2.3/README_OSX1065.txt/view">outlined here</a>
	</li><li>Set the environment variable for gnuplot (Octave is supposed to do this automatically, but it didn't for me):<code>
sudo ln -s /Applications/GnuPlot.app/Contents/Resources/bin/gnuplot /usr/bin/gnuplot
</code>
(thanks for the help, <a href="http://island94.org/setting-octave-and-gnuplot-osx#comment-3654">Toby</a>)</li>
	<li>Download and install (again in /Applications) <a href="http://sourceforge.net/projects/aquaterm/">Aquaterm</a> which will actually render the gnuplot graphs.</li>
	<li>Within Gnuplot, set the renderer: "terminal aqua"</li>
	<li>Try it out in Octave (I had to restart Octave and Gnuplot to get it all to work):<code>
x = linspace(-pi, pi, 100);
y = sin(x);
plot(x, y);
</code></li>
</ol>
Thank you: <a href="http://hpc.sourceforge.net/">High Performance Computing for Mac OS X</a>, <a href="http://wiki.octave.org/wiki.pl?MacOSXIntegration">the Octave Wiki</a> and Google for helping me find what I needed.

<em><strong>Update (January 24, 2010):</strong> updated the link in step #1 to the latest version of Octave. Added an additional step described by <a href="http://www.island94.org/2007/09/setting-up-octave-and-gnuplot-on-osx/#comment-80303">Zack in the comment</a>s (thanks!)</em>
