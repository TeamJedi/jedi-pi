#!/bin/bash -ex
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $DIR

RASBIAN_ZIP=2016-09-23-raspbian-jessie-lite.zip
RASBIAN_SRCIMG=2016-09-23-raspbian-jessie-lite.img
RASBIAN_URL=http://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2016-09-28/${RASBIAN_ZIP}
RASBIAN_SHA1=3a34e7b05e1e6e9042294b29065144748625bea8

RASBIAN_IMG=${RASBIAN_SRCIMG}+host-mode.img

[ -f "${RASBIAN_ZIP}" ] || wget "${RASBIAN_URL}"

ZIP_SHA1="$(openssl sha1 ${RASBIAN_ZIP} | awk '{print $2}')"

[ "${ZIP_SHA1}" = "${RASBIAN_SHA1}" ]

[ -f "${RASBIAN_SRCIMG}" ] || unzip ${RASBIAN_ZIP}
[ -f "${RASBIAN_IMG}" ] ||  cp ${RASBIAN_SRCIMG} ${RASBIAN_IMG}

OS="$(uname -s)"

# Mount the image
case $OS in
Darwin)
	DISK=$(hdiutil attach ${RASBIAN_IMG} | grep Windows_FAT_32 | awk '{print $1}')
	VOLUME=$(hdiutil mount ${DISK} | awk '{print $3}')
	;;
Linux)
	VOLUME=/mnt
	sudo mount -o loop,offset=$((8192 * 512)) ${RASBIAN_IMG} $VOLUME
	;;
esac

cd $VOLUME

grep modules-load=g_ether cmdline.txt > /dev/null 2>&1 || (
  CMDLINE=$(cat cmdline.txt)
  echo "${CMDLINE}" | sed -e 's/rootwait/rootwait modules-load=g_ether/' > cmdline.txt
)

cd $DIR

case $OS in
Darwin)
	hdiutil unmount -quiet ${VOLUME}
	hdiutil detach -quiet ${DISK}
	;;
Linux)
	sudo umount $VOlUME
	;;
esac

