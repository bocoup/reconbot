#!/bin/sh

clean() {
  apt-get autoclean;
  apt-get clean;
  apt-get autoremove;
}

# configure wifi here...


# then...

echo "LANG=en_US.UTF-8" > /etc/default/locale;

apt-get update;
sudo apt-get upgrade;
apt-get install -y sudo;

clean;

# apt-get install -y make
# sudo locale-gen en_US.UTF-8;
# sudo dpkg-reconfigure locales;

wget http://terzo.acmesystems.it/download/webcam/mjpg-streamer.tar.gz;
tar -xvzf mjpg-streamer.tar.gz;
cd mjpg-streamer;
apt-get install -y libjpeg-dev;
apt-get install -y libv4l-dev;
ln -s /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h;


# Comment the following line in the Makefile:
# PLUGINS += input_gspcav1.so
cat Makefile | sed -e "s/PLUGINS += input_gspcav1.so/# PLUGINS += input_gspcav1.so/" > elifekaM;
mv Makefile M4k3f1l3;
mv elifekaM Makefile;

make;


clean;
echo "mjpg-streamer installed.";

curl -o /usr/bin/rmate https://raw.githubusercontent.com/aurora/rmate/master/rmate;
chmod +x /usr/bin/rmate;
mv /usr/bin/rmate /usr/bin/rsub;
echo "rsub installed.";

curl -sL https://deb.nodesource.com/setup_6.x | bash -;
apt-get install -y nodejs;
clean;
echo "node installed.";


cd ~;
mkdir reconbot;
cd reconbot/;
npm init -y;
npm install johnny-five edison-io mraa;
echo "johnny-five installed.";
echo "edison-io installed.";




echo "uvcvideo...";
find / -name uvc*;


lsmod | grep uvc;

$(ls /dev/video0);
