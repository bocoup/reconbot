#!/bin/sh
# run this on the eidson
# screen /dev/tty.usbserial-XXXX 115200
set -e

if [ "$(id -u)" != "0" ]; then
  echo "You must be a root user root:edison" 2>&1
  exit 1
fi

echo 'reconbot-X' > /etc/hostname
echo "set hostname";

# configure wifi here...

# to connect wifi get the has by running
# wpa_passphrase Bocoup PASS_WORD
echo 'auto lo
iface lo inet loopback

Set to auto so we can share our net connection with it
auto usb0
iface usb0 inet static
  address 192.168.42.1
  netmask 255.255.255.0

auto wlan0
iface wlan0 inet dhcp
  wpa-ssid Johnny-5G
  wpa-psk 44d6cc4524bf1fb575e5f501fbdd21895842f3511f3a883652015ea41f57e6e5
  # wpa-ssid intelMF5
  # wpa-psk 7774e583a7f47d8413afeb6f5000c1e15842dc1f8d0e1afc4c7db9858f75a122
  # wpa-ssid Bocoup
  # wpa-psk 63e16c935395e9eea854685d92f3dc5bc73b16174f392475344eeee2d1d5fd57

  # disable power management
  post-up iwconfig wlan0 power off


# And the following 4 lines are for when using hostapd...
' > /etc/network/interfaces

ifdown usb0
ifup usb0
ifdown wlan0
ifup wlan0

# then...

#configure hostap

# # config hostap
# cp /etc/hostapd/hostapd.conf /etc/hostapd/hostapd.conf.bak
# cat /etc/hostapd/hostapd.conf.bak | \
#   sed -e "s/^ssid=edison_ap$/ssid=reconbot-x/" | \
#   sed -e "s/^channel=1$/channel=acs_survey/" | \
#   sed -e "s/^wpa_passphrase=.*$/wpa_passphrase=johnny-five/" \
#   sed -e "/s/^hw_mode=g$/hw_mode=ad/" \
#   > /etc/hostapd/hostapd.conf

# # enable the config file so it starts
# cp /etc/init.d/hostapd /root/hostapd.init.bak
# cat /root/hostapd.init.bak | \
#   sed -e "s/^DAEMON_CONF=$/DAEMON_CONF=\/etc\/hostapd\/hostapd.conf/" \
#   > /etc/init.d/hostapd

# # start it



# setup Rick and Francis ssh keys
# replace this with your own if you like
mkdir -p /root/.ssh
curl -s https://github.com/reconbot.keys >> /root/.ssh/authorized_keys
curl -s https://github.com/rwaldron.keys >> /root/.ssh/authorized_keys


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

# MJPG Streamer setup
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
cd /root/;
git clone https://github.com/bocoup/reconbot.git
cd reconbot;
npm install --verbose;
