#!/bin/bash -e

ver="$(rsync --version | head -1 | awk '{print $3}' | cut -d. -f1-2)"
if echo "$ver < 3.1" | bc 2>&1 > /dev/null ; then
  cat <<EOM

  This script requires rsync 3.1 or later
  If you are on a mac with the older 2.6.9 rsync, you may want to run:

    brew install rsync ; hash -r

EOM
  exit 1
fi

set -x

# Copy up your creds
ssh-copy-id pi@raspberrypi.local

# Copy the files
rsync -aq --rsync-path='sudo rsync' --chown pi:pi overlay/home/pi/ pi@raspberrypi.local:.
rsync -aq --rsync-path='sudo rsync' --chown root:root overlay/etc/olsrd/ pi@raspberrypi.local:/etc/olsrd/
