#!/bin/sh
# run this on the eidson
# screen /dev/tty.usbserial-XXXX 115200
set -e

if [ "$(id -u)" != "0" ]; then
  echo "You must be a root user root:edison" 2>&1
  exit 1
fi

# setup upstart services for streamer and the bandit
# echo '
# description "daemon for api"

# start on started network-services
# stop on shutdown
# respawn limit 4 0

# script
#   /root/reconbot/streamer.sh
# end script
# ' > /etc/init/streamer.conf

# echo '
# description "daemon for reconbot"

# start on started network-services
# stop on shutdown
# respawn limit 4 0

# env NODE_ENV=production

# script
#   /usr/bin/npm run start --prefix /root/reconbot/
# end script

# ' > /etc/init/reconbot.conf


# service streamer start
# service reconbot start

# setup reconbot system V startup scripts

echo '
#!/bin/sh
### BEGIN INIT INFO
# Provides:          reconbot
### END INIT INFO

case "$1" in
  start)
      cd /root/reconbot
      ./streamer.sh &
      npm run start &
      ;;
  stop)
    killall mjpg_streamer
    killall node
    ;;
  *)
    echo "Usage: reconbot [start|stop]" >&2
    exit 3
  ;;
esac

:

' > /etc/init.d/reconbot
chmod +x /etc/init.d/reconbot
# ln -s /etc/init.d/reconbot /etc/rc5.d/S04reconbot
