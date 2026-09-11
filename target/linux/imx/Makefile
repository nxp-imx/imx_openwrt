# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2013-2014,2025 OpenWrt.org

include $(TOPDIR)/rules.mk

BOARD:=imx
BOARDNAME:=NXP i.MX
FEATURES:=audio display fpu gpio pcie rtc usb usbgadget squashfs targz nand ubifs boot-part rootfs-part
SUBTARGETS:=cortexa7 cortexa9 cortexa53

KERNEL_PATCHVER:=6.12

# The i.MX kernel builds the ALSA sound core in-kernel (CONFIG_SND=y and
# friends), so the individual soundcore .ko modules do not exist. Override
# the soundcore file/load lists (see package/kernel/linux/modules/sound.mk)
# to be empty so kmod-sound-core becomes an empty "provides" package that
# still satisfies alsa-lib's dependency instead of failing to build on the
# missing snd-*.ko files.
SOUNDCORE_LOAD:=
SOUNDCORE_FILES:=

include $(INCLUDE_DIR)/target.mk

DEFAULT_PACKAGES += uboot-envtools mkf2fs e2fsprogs blkid

$(eval $(call BuildTarget))
