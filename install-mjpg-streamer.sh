#!/bin/sh
# MJPG Streamer setup

set -e # stop on errors
set -x # display every command as it's run

apt-get update
apt-get install -y libjpeg-dev libv4l-dev
apt-get autoremove -y
apt-get clean -y

wget http://terzo.acmesystems.it/download/webcam/mjpg-streamer.tar.gz
tar -xvzf mjpg-streamer.tar.gz
cd mjpg-streamer
ln -s /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h

# Comment the following line in the Makefile:
# PLUGINS += input_gspcav1.so
cat Makefile | sed -e "s/PLUGINS += input_gspcav1.so/# PLUGINS += input_gspcav1.so/" > elifekaM;
mv Makefile M4k3f1l3;
mv elifekaM Makefile;

make
make install
cd ../
rm -rf mjpg-streamer
