# Reusing the Raspbian sdcard

If you are reusing an sdcard from Raspbian, you will need to rename the vfat partition: <https://gitlab.alpinelinux.org/alpine/aports/-/issues/12368>

> Raspberry Pi fails to boot when volume label is "boot" (e.g. after overwriting Raspbian)
> Raspberry Pi fails to boot and repeatedly blinks LED 7 times, meaning "kernel not found". If BOOT_UART=1 is set, the messages "Failed to load 'boot/initramfs-rpi' - initramfs disabled" and "No compatible kernel found" are printed to serial. This is caused by the volume label being "boot", which Raspbian/Raspberry Pi OS have in their official images

It's because of this bug: https://github.com/raspberrypi/firmware/issues/1529
