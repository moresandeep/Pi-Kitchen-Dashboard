#!/bin/sh
xset -dpms # disable DPMS (Energy Star) features.
xset s off # disable screen saver
xset s noblank # don't blank the video device
unclutter -idle 0.1 &
# Launch window manager without title bar.
matchbox-window-manager -use_titlebar no -use_cursor no -theme bluebox &
# Update the index.html path
midori -e Fullscreen -a file:///home/more/dev/Pi-Kitchen-Dashboard/index.html
