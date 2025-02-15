**This project is not maintained and is presented for archival purposes only**

# Pi Kitchen Dashboard
##### Because thrift store monitors still need things to do.

This project turns your monitor and Raspberry Pi into a simple, skinnable time and weather dashboard for your kitchen. Want it in your living room? **Too bad.**

![alt text](https://lh5.googleusercontent.com/OvyLwyLtXF69AJ-8U68OPnLXhZNwOPG7JYv5i-fa_44=w1167-h875-no "Pi Kitchen Dashboard")

* * *

+ [Items Needed](#itemsNeeded)
+ [Instructions](#instructions)
    - [Cloning](#cloning)
    - [Fulfilling requirements](#fulfillingRequirements)
    - [Setting your location](#settingYourLocation)
    - [Configuring your Pi](#configuringYourPi)
        * [Disallowing screen sleep](#disallowingScreenSleep)
        * [Installing Unclutter](#hidingCursor)
		* [Rotate Screen](#rotateScreen)
		* [Kiosk Mode](#kiosk)
    - [Scheduling screen sleep](#scheduling)
+ [Changing the skin](#changingTheSkin)
+ [Creating skins](#creatingSkins)
+ [Credit](#credit)

* * *

## <a name="itemsNeeded"></a>Items needed

+ Raspberry Pi
+ Monitor
+ Adapter to hook said Raspberry Pi to said monitor
+ Internet connection

## <a name="instructions"></a>Instructions

### <a name="cloning"></a>Cloning

Clone this repository with `git clone https://github.com/userexec/Pi-Kitchen-Dashboard.git`.

If your Pi does not currently have git, you will need to install it first with `sudo apt-get install git`.

### <a name="fulfillingRequirements"></a>Fulfilling requirements

This project is not distributed with its dependencies; however, [Bower](http://bower.io/) will automatically pull them in.

1. `sudo apt-get update && sudo apt-get upgrade` - Update your system
2. Install Node Package Manager (required for Bower) 

  ##### Raspberry Pi A/B/B+

  ```
  wget https://nodejs.org/dist/v4.0.0/node-v4.0.0-linux-armv6l.tar.gz 
  tar -xvf node-v4.0.0-linux-armv6l.tar.gz 
  cd node-v4.0.0-linux-armv6l
  sudo cp -R * /usr/local/
  ```

  ##### Raspberry Pi 2 Model B

  ```
  wget https://nodejs.org/dist/v4.0.0/node-v4.0.0-linux-armv7l.tar.gz 
  tar -xvf node-v4.0.0-linux-armv7l.tar.gz 
  cd node-v4.0.0-linux-armv7l
  sudo cp -R * /usr/local/
  ```
  <a href="http://blog.wia.io/installing-node-js-v4-0-0-on-a-raspberry-pi/">Node install instructions</a> by <a href="http://blog.wia.io/author/conall/">Conall Laverty</a>
    

3. `sudo npm install -g bower` - Install Bower
4. `cd ~/Pi-Kitchen-Dashboard` - cd into the directory of the cloned project
5. `bower install` - Install the project's dependencies

### <a name="settingYourLocation"></a>Setting your location

Open `js/weather.js` and find the following section at the top:

```javascript
// Your openweather api key 
var api_key = 23416998123343434254545;

// your zip code
var zip_code = '12345'

// Your temperature unit measurement
// This bit is simple, 'c' for Celcius, and 'f' for Fahrenheit
var unit = 'c';

// query interval (milliseconds)
// Default is every 15 minutes. Be reasonable. Don't query Yahoo every 500ms.
var waitBetweenWeatherQueriesMS = 900000;
```

Change these variables to match your location, unit measurement, and desired update interval, and your part of the coding is done!

### <a name="configuringYourPi"></a>Configuring your Pi

You will need a Raspberry Pi (although you could use anything else) with Raspbian (again, or anything else) and an internet connection. To complete the dashboard, your Pi will need disallow screen sleep and automatically start kiosk mode.

#### <a name="disallowingScreenSleep"></a>Disallowing screen sleep

Unless screen sleep is prevented, the dashboard screen will go black after a few minutes and require a mouse movement or keypress to wake up. Scheduled times for the display to turn off are covered in a [later section](#scheduling).

`sudo nano /etc/lightdm/lightdm.conf`

Add the following lines to the [SeatDefaults] section:

```bash
xserver-command=X -s 0 -dpms
```

#### <a name="hideCursor"></a>Installing Unclutter

Unclutter causes the mouse cursor to disappear when the mouse isn't being moved. This prevents the dash from having a cursor over the middle unless you plug in a mouse and move it elsewhere.

`sudo apt-get install unclutter`


#### <a name="kiosk"></a>Kiosk Mode

1. Update `kiosk.sh` script with the correct path to `index.html` and correct user
2. Update file permissions `sudo chmod +x kiosk.sh`

##### <a name="startAtBoot"></a>Setup Kiosk at Boot
* Create a kiosk service `sudo vi /lib/systemd/system/kiosk.service` make sure to update the `DISPLAY` and `user` values
```
[Unit]
Description=Chromium Kiosk
Wants=graphical.target
After=graphical.target

[Service]
Environment=DISPLAY=:0.0
Environment=XAUTHORITY=/home/<user>/.Xauthority
Type=simple
ExecStart=/bin/bash /home/<user>/dev/kiosk.sh
Restart=on-abort
User=<user>
Group=<user>

[Install]
WantedBy=graphical.target
```
* Enable kiso service on boot `sudo systemctl enable kiosk.service`
* Start the service `sudo systemctl start kiosk.service`
* Check service status `sudo systemctl status kiosk.service`

#### <a name="rotateScreen"></a>Rotate Screen
1. Open the config.txt file with the Nano editor
 1. `sudo vi /boot/config.txt`
2. Add the following test at the beginning of the `config.txt` file.
 1. `display_rotate=2` 
 2. other options 
 ```
 display_rotate=0 Normal
 display_rotate=1 90 degrees
 display_rotate=2 180 degrees
 display_rotate=3 270 degrees
 display_rotate=0x10000 Mirror horizontal
 display_rotate=0x20000 Mirror vertical
 ```
3. `sudo reboot`
### <a name="scheduling"></a>Scheduling screen sleep

If you don't want your display to run 24/7, you can use cron jobs to fire a pair of included bash scripts: screenOff.sh and screenOn.sh. Please ensure you've completed the [Disallowing screen sleep](#disallowingScreenSleep) step above in order to keep the display always on during the times it's scheduled to be on.

1. `cd` into your Pi-Kitchen-Dashboard directory and set both scripts to executable
	
	```bash
	chmod +x screenOff.sh
	chmod +x screenOn.sh
	```

2. Run `crontab -e` and add cronjobs to the end using the provided scripts. If you're not comfortable writing cronjobs manually, you can use a <a href="http://cron.nmonitoring.com/cron-generator.html">crontab generator</a>. The following lines, for example, shut off the display at 11:00PM each night and turn it back on at 6:00AM. Be sure to edit the file paths if necessary.
	
	```
	0 23 * * * /home/pi/Pi-Kitchen-Dashboard/screenOff.sh
	0 6 * * * /home/pi/Pi-Kitchen-Dashboard/screenOn.sh
	```

## <a name="changingTheSkin"></a>Changing the skin

Skins are kept, conveniently, in the skins folder. To switch skins, edit `Pi-Kitchen-Dashboard/index.html` and insert the folder name of the skin you wish to use where the comments direct.

## <a name="creatingSkins"></a>Creating skins

Creating your own skin or a new skin for distribution is easy and only requires knowledge of HTML and CSS. Just copy the `default` folder under skins, rename it, and begin editing. Comments in the default skin will guide you through the process, but it basically boils down to 99% using your imagination and 1% placing a few IDs and classes so that time and weather data can be auto-populated.

## <a name="credit"></a>Credit

Weather icons by Lukas Bischoff and Erik Flowers https://github.com/erikflowers/weather-icons. Icons licensed under [SIL OFL 1.1](http://scripts.sil.org/OFL).  

Time formatting by [Moment.js](http://momentjs.com/)  

Weather data retrieved using Yahoo! Weather API.

Default skin responsiveness by [RYJASM](https://github.com/ryjasm).

Project is under [MIT license](http://choosealicense.com/licenses/mit/).  


## Troubleshooting

* In case you decide to create a new user and not use `pi` user and are using HDMI make sure you add `video` group to your user
	* `sudo usermod -aG video <username>`