#!/bin/bash -e

need='3.1'
have="$(rsync --version | head -1 | awk '{print $3}' | cut -d. -f1-2)"
newer="$(echo -e "$have\n$need" | sed '/^$/d' | sort -nr | head -1)"
if [[ "$newer" != "$have" ]] ; then
  echo $?
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

# Make sure rsync is on the pi
ssh pi@raspberrypi.local "bash -c 'which rsync || ( sudo apt-get update && sudo apt-get install -y rsync )'"

# Copy the files
rsync -aq --rsync-path='sudo rsync' --chown pi:pi overlay/home/pi/ pi@raspberrypi.local:.
rsync -aq --rsync-path='sudo rsync' --chown root:root overlay/etc/ pi@raspberrypi.local:/etc/
