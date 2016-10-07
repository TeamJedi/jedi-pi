# jedi-pi

## ethernet-device-mode.sh

This script attempts to follow the PI zero OTG / ethernet gadget guide:

https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/ethernet-gadget
http://blog.gbaman.info/?p=791
https://gist.github.com/gbaman/50b6cca61dd1c3f88f41
https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a

After running this script, you will have a `*+device-mode.img` file that needs to be written to the micro-SD card of your choosing.

This image can be used with a raspberry pi zero _without_ a USB HAT.

This means you can connect your raspberry pi zero, alone, to a host machine doing internet sharing to the RNDIS interface, and it will be able to obtain an IP address that you can reach from that host machine.

# ethernet-host-mode.sh

This script automagically loads the `g_ether` device driver for a USB network connection, but does _not_ enable the device mode by loading the `dwc2` device driver.

After running this script, you will have a `*+host-mode.img` file that needs to be written to the micro-SD card of your choosing.

the jedi-pi project now has a `ethernet-device-mode.sh` script, and a `ethernet-host-mode.sh` script.

The latter generates a `2016-09-23-raspbian-jessie-lite.img+host-mode.img` 

This image can be used with a raspberry pi zero _with_ a USB HAT.

This means that you can connect your raspberry pi zero with a USB HAT to a wifi connected android device that has USB tether enabled, and it will be able to obtain an IP address that you can reach from that phone (via `adb shell` over an `adb tcpip` connection).

## Flashing the disk image

Safely power off your Raspberry PI Zero and eject the SDCARD, and insert it into your development workstation.

Here is an easy way to find the device that appears on a Mac:

    $ mount | grep "/Volumes/NO NAME" | awk '{print $1}'
    /dev/disk3s1

That shows that my micro-SD card is /dev/disk3. That first slice `s1` is the first partition with the "NO NAME" filesystem.

We can unmount that filesystem, while still leaving the device attached (do not eject):

    hdiutil unmount "/Volume/NO NAME"

Now we can _OVERWRITE_ the micro-SD card with the `dd` command.

    sudo dd if=2016-09-23-raspbian-jessie-lite.img+device-mode.img of=/dev/disk3 bs=1M

WARNING: Choose the `of=` device carefully. There is no recovery from this action.

When this command finishes, it should be safe to eject the card and put it back in your Raspberry PI Zero.

## Initially tethering out through OS/X

If you enable OS/X Internet Sharing, the raspberry pi zero has a small problem with ipv6 that causes it to not be able to get out correctly.

To fix this, edit `/etc/modprobe.d/ipv6.conf` and uncomment the `alias ipv6 off` and reboot the raspberry pi zero.

    sudo sed -i -e 's/#alias ipv6 off/alias ipv6 off/' /etc/modules.d/ipv6.conf
    sudo shutdown -r now

## Applying the overlay

The `apply.sh` script can be used to copy up the `overlay/` contents.

## 3d Box Assembly

The [3d](3d/) folder contains the Fusion 3d box assembly for the Jedi device.

