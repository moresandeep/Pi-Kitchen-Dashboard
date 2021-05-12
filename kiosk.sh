#!/bin/bash
xset s noblank
xset s off
xset -dpms

unclutter -idle 0.5 -root &

sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' /home/<user>/.config/chromium/Default/Preferences
sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' /home/<user>/.config/chromium/Default/Preferences

/usr/bin/chromium-browser --disable-infobars --kiosk --ignore-certificate-errors --disable-restore-session-state file:///home/<user>/dev/Pi-Kitchen-Dashboard/index.html