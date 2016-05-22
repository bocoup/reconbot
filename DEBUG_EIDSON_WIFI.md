# debug

At makerfaire we observed weird wifi issues that were not seen during development. The Wifi would cutout when we started our johnny-five server. The following steps would fix it.

With a newly booted board running on battery power, and a serial console.

 - SSH to the bot
 - run `tmux` this will keep all program running if you get disconnected
 - `cd reconbot`
 - `./streamer.sh &`
 - `npm start`

At this point you'll probably loose network connectivity. If you serial console in you can "bounce" the interface and bring it back.

 - Attach a cable to the serial console USB port (the left port)
 - run `screen /dev/cu.usbserial-XXXXX 115200` where XXX is a unique port name for the edison. You can use tab completion to discover it.
 - hit enter and login as root
 - run `ifdown wlan0 && ifup wlan0`
 - Wait 5-30 seconds and now your edison is back online and ready to rock and roll
