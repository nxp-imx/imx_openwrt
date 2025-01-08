# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024-2025 OpenWrt.org

DEVICE_VARS += UBOOT

include common.mk

IMX_SD_KERNEL_PARTSIZE = 20
IMX_SD_KERNELPART_OFFSET = 1
IMX_SD_ROOTFSPART_OFFSET = 32
IMX_SD_ROOTFS_PARTSIZE = 100
IMX_SD_IMAGE_SIZE = $(shell echo $$((($(IMX_SD_KERNEL_PARTSIZE) + \
	$(IMX_SD_ROOTFS_PARTSIZE)))))

define Build/boot-img-ext4
	rm -fR $@.boot
	mkdir -p $@.boot
	$(foreach dts,$(DEVICE_DTS), $(CP) $(KDIR)/image-$(dts).dtb $@.boot/$(dts).dtb;)
	$(CP) $(IMAGE_KERNEL) $@.boot/$(KERNEL_NAME)
	make_ext4fs -J -L kernel -l $(IMX_SD_KERNEL_PARTSIZE)M \
		$(if $(SOURCE_DATE_EPOCH),-T $(SOURCE_DATE_EPOCH)) \
		$@.bootimg $@.boot
endef

define Build/sdcard-img-ext4
	SIGNATURE="$(IMG_PART_SIGNATURE)" \
	PARTOFFSET="$(IMX_SD_KERNELPART_OFFSET)"M PADDING=1 \
		$(if $(filter $(1),efi),GUID="$(IMG_PART_DISKGUID)") $(SCRIPT_DIR)/gen_image_generic.sh \
		$@ \
		${IMX_SD_KERNEL_PARTSIZE} $@.boot \
		$(IMX_SD_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS) \
		1024
endef

define Build/imx-clean
	# Clean the target
	echo $(IMAGE_KERNEL) , $(IMAGE_ROOTFS)
	rm -f $@
endef

define Build/imx-append
	# append binary
	dd if=$(STAGING_DIR_IMAGE)/$(1) >> $@
endef

define Build/imx-append-env
	# append env binary
	dd if=$(STAGING_DIR_IMAGE)/$(1) of="$@" bs=1k seek=896 conv=notrunc
endef

define Build/imx-append-boot
	# Append the uboot, firmware etc.
	dd if=$(STAGING_DIR_IMAGE)/$(1) of="$@" bs=1K seek=1 conv=notrunc
endef

define Build/imx-append-kernel
	# append the kernel
	mkdir -p $@.tmp && \
	cp $(IMAGE_KERNEL) $@.tmp && \
	cp $(KDIR)/image-$(firstword $(1)).dtb $@.tmp && \
	make_ext4fs -J -L kernel -l "$(IMX_SD_KERNELPART_SIZE)M" "$@.kernel.part" "$@.tmp" && \
	dd if=$@.kernel.part >> $@ && \
	rm -rf $@.tmp && \
	rm -f $@.kernel.part
endef

define Build/imx-append-uboot
	# append boot loader image
	dd if=$(STAGING_DIR_IMAGE)/$(1) >> $@
endef

define Build/imx-append-sdhead
	# Create the sd file table
	./gen_sdcard_head_img.sh $(STAGING_DIR_IMAGE)/$(1)-sdcard-head.img \
		$(IMX_SD_KERNELPART_OFFSET) $(IMX_SD_KERNELPART_SIZE) \
		$(IMX_SD_ROOTFSPART_OFFSET) $(CONFIG_TARGET_ROOTFS_PARTSIZE)
	dd if=$(STAGING_DIR_IMAGE)/$(1)-sdcard-head.img >> $@
endef

define Device/Default
  PROFILES := Default
  FILESYSTEMS := squashfs ext4
  KERNEL_INSTALL := 1
  KERNEL_SUFFIX := -uImage
  KERNEL_NAME := zImage
  KERNEL := kernel-bin | uImage none
  KERNEL_LOADADDR := 0x80008000
  DTS_DIR := $(DTS_DIR)/nxp/imx
  IMAGES :=
endef

define Device/technexion_imx7d-pico-pi
  DEVICE_VENDOR := TechNexion
  DEVICE_MODEL := PICO-PI-IMX7D
  UBOOT := pico-pi-imx7d
  DEVICE_DTS := imx7d-pico-pi
  DEVICE_PACKAGES := kmod-sound-core kmod-sound-soc-imx kmod-sound-soc-imx-sgtl5000 \
	kmod-can kmod-can-flexcan kmod-can-raw kmod-leds-gpio \
	kmod-input-touchscreen-edt-ft5x06 kmod-usb-hid kmod-btsdio \
	kmod-brcmfmac brcmfmac-firmware-4339-sdio cypress-nvram-4339-sdio
  FILESYSTEMS := squashfs
  IMAGES := combined.bin sysupgrade.bin
  IMAGE/combined.bin := append-rootfs | pad-extra 128k | imx-sdcard-raw-uboot
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += technexion_imx7d-pico-pi

define Device/imx6ull
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX6ULL
  DEVICE_VARIANT := SD Card Boot
  BOARD_NAME := iMX6ULL
  ENV_NAME:=imx6ull-sdboot
  DEVICE_PACKAGES += \
	firmware-sdma \
	u-boot-imx6ull
  UBOOT_NAME:=imx6ull-u-boot-dtb.imx
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/nxp/imx/imx6ull-*.dts)))
  KERNEL := kernel-bin
  KERNEL_SUFFIX := -zImage
  IMAGES := sdcard.img
  IMAGE/sdcard.img := \
	imx-clean | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(UBOOT_NAME) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx6ull
