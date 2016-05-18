#!/bin/sh
/usr/local/bin/mjpg_streamer -i "input_uvc.so -q 50 -f 15 -r 320x240 -y YUYV" -o "output_http.so"
