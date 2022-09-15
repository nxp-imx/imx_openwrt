# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP

# 16MB bootloader + 40MB kernel
IMX_SD_KERNELPART_SIZE = 20
IMX_SD_KERNELPART_OFFSET = 1
IMX_SD_ROOTFSPART_OFFSET = 32
IMX_SD_IMAGE_SIZE = $(shell echo $$((($(IMX_SD_ROOTFSPART_OFFSET) + \
	$(CONFIG_TARGET_ROOTFS_PARTSIZE)))))

define Build/imx-clean
	# Clean the target
	echo $(IMAGE_KERNEL) , $(IMAGE_ROOTFS)
	rm -f $@
endef

define Build/imx-append
	# append binary
	dd if=$(STAGING_DIR_IMAGE)/$(1) >> $@
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
  IMAGES := sdcard.img
endef

define Device/imx6ull
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX6ULL
  DEVICE_VARIANT := SD Card Boot
  BOARD_NAME := iMX6ULL
  ENV_NAME:=imx6ull-sdboot
  DEVICE_PACKAGES += u-boot-imx6ull
  UBOOT_NAME:=imx6ull-u-boot-dtb.imx
  DEVICE_DTS := imx6ull-14x14-evk
  KERNEL := kernel-bin
  KERNEL_SUFFIX := -zImage
  IMAGE/sdcard.img := \
		imx-clean | \
		imx-append-sdhead $(1) | pad-to 1K | \
		imx-append-uboot $$(UBOOT_NAME) | pad-to 768K | \
		imx-append $$(ENV_NAME)-uboot-env.bin | pad-to $(IMX_SD_KERNELPART_OFFSET)M | \
		imx-append-kernel $$(DEVICE_DTS) | pad-to $(IMX_SD_ROOTFSPART_OFFSET)M | \
		append-rootfs | pad-to $(IMX_SD_IMAGE_SIZE)M
endef
TARGET_DEVICES += imx6ull
