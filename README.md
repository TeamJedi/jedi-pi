# jedi-pi

## ethernet-gadget.sh

This script attempts to follow the PI zero OTG / ethernet gadget guide:

https://learn.adafruit.com/turning-your-raspberry-pi-zero-into-a-usb-gadget/ethernet-gadget
http://blog.gbaman.info/?p=791
https://gist.github.com/gbaman/50b6cca61dd1c3f88f41
https://gist.github.com/gbaman/975e2db164b3ca2b51ae11e45e8fd40a

After running this script, you will have an img file that needs to be written to the micro-SD card of your choosing.

## Flashing the disk image

Safely power off your Raspberry PI Zero and eject the SDCARD, and insert it into your development workstation.

Here is an easy way to find the device that appears on a Mac:

    $ mount | grep "/Volumes/NO NAME" | awk '{print $1}'
    /dev/disk3s1

That shows that my micro-SD card is /dev/disk3. That first slice `s1` is the first partition with the "NO NAME" filesystem.

We can unmount that filesystem, while still leaving the device attached (do not eject):

    hdiutil unmount "/Volume/NO NAME"

Now we can _OVERWRITE_ the micro-SD card with the `dd` command.

    sudo dd if=2016-09-23-raspbian-jessie-lite_ethernet-gadget.img of=/dev/disk3 bs=1M

WARNING: Choose the `of=` device carefully. There is no recovery from this action.

When this command finishes, it should be safe to eject the card and put it back in your Raspberry PI Zero.

