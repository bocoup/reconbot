#!/bin/sh
set -e # stop on errors
set -x # display every command as it's run

/usr/local/bin/mjpg_streamer -i "input_uvc.so -f 15 -r 960x720" -o "output_http.so" &
npm run start
