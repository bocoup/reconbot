#!/bin/sh
# run this on the eidson
# screen /dev/tty.usbserial-XXXX 115200
set -e

if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user root:edison" 2>&1
  exit 1
fi

echo 'reconbot-x' > /etc/hostname

# setup Rick and Francis ssh keys
# replace this with your own if you like
mkdir -p /root/.ssh
curl -s https://github.com/reconbot.keys >> /root/.ssh/authorized_keys
curl -s https://github.com/rwaldron.keys >> /root/.ssh/authorized_keys

# configure wifi here...

# to connect wifi get the has by running
# wpa_passphrase Bocoup PASS_WORD
echo 'auto lo
iface lo inet loopback

Set to auto so we can share our net connection with it
auto usb0
iface usb0 inet dhcp

auto wlan0
iface wlan0 inet dhcp
    wpa-ssid Bocoup
    wpa-psk 63e16c935395e9eea854685d92f3dc5bc73b16174f392475344eeee2d1d5fd57
    post-up iwconfig wlan0 power off

# And the following 4 lines are for when using hostapd...
#auto wlan0
#iface wlan0 inet static
#    address 192.168.42.1
#    netmask 255.255.255.0
' > /etc/network/interfaces

ifdown usb0
ifup usb0
ifdown wlan0
ifup wlan0

# then...

# setup locals
# echo -e 'LANG="en_US.UTF-8"\nLANGUAGE="en_US:en"\n' > /etc/default/locale;
# locale-gen --purge en_US.UTF-8;

# setup nodejs sources
curl -sL https://deb.nodesource.com/setup_6.x | bash -;

# packages to install
# apt-get update # done automatically by nodesource
apt-get upgrade -y;
apt-get install -y sudo libjpeg-dev libv4l-dev nodejs htop tmux;

# remove packages not needed anymore and then all downloaded .deb files
apt-get autoremove -y;
apt-get clean -y;

wget http://terzo.acmesystems.it/download/webcam/mjpg-streamer.tar.gz;
tar -xvzf mjpg-streamer.tar.gz;
cd mjpg-streamer;
ln -s /usr/include/libv4l1-videodev.h /usr/include/linux/videodev.h;

# Comment the following line in the Makefile:
# PLUGINS += input_gspcav1.so
cat Makefile | sed -e "s/PLUGINS += input_gspcav1.so/# PLUGINS += input_gspcav1.so/" > elifekaM;
mv Makefile M4k3f1l3;
mv elifekaM Makefile;

#todo add to path and maybe make install

make;
make install;
# setup the library path for mjpg-streamer because it isn't setup by default
echo '
LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
' > /etc/profile.d/mjpg-streamer.sh
echo "mjpg-streamer installed.";

curl -o /usr/bin/rmate https://raw.githubusercontent.com/aurora/rmate/master/rmate;
chmod +x /usr/bin/rmate;
mv /usr/bin/rmate /usr/bin/rsub;
echo "rsub installed.";

# setup the latest npm
npm config -g set progress=false
npm install -g npm;

# clone and install the reconbot
cd ~;
git clone https://github.com/bocoup/reconbot.git
cd reconbot;
npm install --verbose;


# echo "uvcvideo...";
# find / -name uvc*;
# lsmod | grep uvc;
# $(ls /dev/video0);
