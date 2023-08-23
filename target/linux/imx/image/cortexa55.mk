# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2023 NXP

define Device/Default
  PROFILES := Default
  FILESYSTEMS := squashfs
  KERNEL_INITRAMFS = kernel-bin
  KERNEL_LOADADDR := 0x80080000
  KERNEL_ENTRY_POINT := 0x80080000
  IMAGE_SIZE := 64m
  KERNEL = kernel-bin
  IMAGES := sdcard.img sysupgrade.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef

define Device/imx93evk
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX93
  DEVICE_VARIANT := SD Card Boot
  BOARD_NAME := iMX9
  SOC_TYPE := iMX9
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx93-sdboot
  DEVICE_PACKAGES += \
	atf-imx93 \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx93
  DEVICE_DTS := freescale/imx93-11x11-evk
  IMAGE/sdcard.img := \
	imx-compile-dtb $$(DEVICE_DTS) | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	imx-clean | \
	imx-append-sdhead $(1) | pad-to 32K | \
	imx-append-boot $$(SOC_TYPE) | pad-to 4M | \
	imx-append $$(ENV_NAME)-uboot-env.bin | pad-to $(IMX_SD_KERNELPART_OFFSET)M | \
	imx-append-kernel $$(DEVICE_DTS) | pad-to $(IMX_SD_ROOTFSPART_OFFSET)M | \
	append-rootfs | pad-to $(IMX_SD_IMAGE_SIZE)M
endef
TARGET_DEVICES += imx93evk
