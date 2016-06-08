#!/bin/sh
set -e # stop on errors
set -x # display every command as it's run

/usr/local/bin/mjpg_streamer -i "input_uvc.so -q 50 -f 15 -r 320x240 -y YUYV" -o "output_http.so" &
npm run start
