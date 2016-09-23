#!/bin/sh
# run this on the Edison

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
#   wpa_passphrase WIFI_SSID PASSWORD
echo 'auto lo
iface lo inet loopback

# Set to auto so we can share our net connection with it
auto usb0
iface usb0 inet static
  address 192.168.42.1
  netmask 255.255.255.0

auto wlan0
iface wlan0 inet dhcp
  wpa-ssid Johnny-5G
  wpa-psk 44d6cc4524bf1fb575e5f501fbdd21895842f3511f3a883652015ea41f57e6e5

  # disable power management
  post-up iwconfig wlan0 power off


# And the following 4 lines are for when using hostapd...
' > /etc/network/interfaces

ifdown usb0
ifup usb0
ifdown wlan0
ifup wlan0

# setup Rick and Francis ssh keys
# replace this with your own if you like
# mkdir -p /root/.ssh
# curl -s https://github.com/reconbot.keys >> /root/.ssh/authorized_keys
# curl -s https://github.com/rwaldron.keys >> /root/.ssh/authorized_keys

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
./install-mjpg-streamer.sh
# setup the library path for mjpg-streamer because it isn't setup by default
echo '
LD_LIBRARY_PATH=/usr/local/lib/:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH
' > /etc/profile.d/mjpg-streamer.sh
echo "mjpg-streamer installed.";

# install rmate for remote file editing
curl -o /usr/bin/rmate https://raw.githubusercontent.com/aurora/rmate/master/rmate;
chmod +x /usr/bin/rmate;
mv /usr/bin/rmate /usr/bin/rsub;
echo "rsub installed.";

# clone and install the reconbot
cd /root/;
git clone https://github.com/bocoup/reconbot.git
cd reconbot;
npm install --verbose;
