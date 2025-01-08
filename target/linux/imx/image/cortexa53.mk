# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024-2025 OpenWrt.org

IMX_SD_KERNEL_PARTSIZE = 64
IMX_SD_KERNELPART_OFFSET = 16
IMX_SD_ROOTFSPART_OFFSET = 56
IMX_SD_ROOTFS_PARTSIZE = 100
IMX_SD_IMAGE_SIZE = $(shell echo $$((($(IMX_SD_KERNEL_PARTSIZE) + \
	$(IMX_SD_ROOTFS_PARTSIZE)))))

define Build/boot-scr
	rm -f $@-boot.scr
	mkimage -A arm64 -O linux -T script -C none -a 0 -e 0 \
		-d bootscript-$(BOOT_SCRIPT) $@-boot.scr
endef

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
	rm -f $@
endef

define Build/imx-create-flash
	# Combile firmware + bl31 + uboot to flash.bin
	cd $(STAGING_DIR_IMAGE)/imx-mkimage && $(MAKE) SOC=$(1) $(2)
endef

define Build/imx-append-env
	# append env binary
	dd if=$(STAGING_DIR_IMAGE)/$(1) of="$@" bs=1M seek=7 conv=notrunc
endef

define Build/imx-append-boot
	# Append the uboot, firmware etc.
	dd if=$(STAGING_DIR_IMAGE)/imx-mkimage/iMX8M/flash.bin of="$@" bs=1K seek=$(1) conv=notrunc
endef

define Build/imx-append-kernel
	# append the kernel
	mkdir -p $@.tmp && \
	cp $(IMAGE_KERNEL) $@.tmp && \
	cp $(DTS_DIR)/$(1).dtb $@.tmp && \
	make_ext4fs -J -L kernel -l "$(IMX_SD_KERNEL_PARTSIZE)M" "$@.kernel.part" "$@.tmp" && \
	dd if=$@.kernel.part >> $@ && \
	rm -rf $@.tmp && \
	rm -f $@.kernel.part
endef

define Device/Default
  PROFILES := Default
  FILESYSTEMS := squashfs ext4
  DEVICE_DTS_DIR := $(DTS_DIR)/freescale
  KERNEL_INSTALL := 1
  KERNEL_NAME := Image
  KERNEL := kernel-bin
  IMAGES := sdcard.img sysupgrade.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef

define Device/imx8mplus
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX8MPLUS
  DEVICE_VARIANT := SD Card Boot
  BOARD_NAME := iMX8MP
  SOC_TYPE := iMX8M
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_evk
  ENV_NAME:=imx8mp-sdboot
  DEVICE_PACKAGES += \
	atf-imx8mp \
	firmware-imx \
	imx-mkimage \
	u-boot-imx8mp
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx8mp-evk*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(BOOT_OFFSET) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx8mplus

define Device/imx8mmini
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX8MMINI
  DEVICE_VARIANT := SD Card Boot
  BOARD_NAME := iMX8MM
  SOC_TYPE := iMX8M
  BOOT_OFFSET := 33
  BOOT_TYPE := flash_evk
  ENV_NAME:=imx8mm-sdboot
  DEVICE_PACKAGES += \
	atf-imx8mm \
	firmware-imx \
	imx-mkimage \
	u-boot-imx8mm
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx8mm-evk-*.dts) $(DTS_DIR)/freescale/imx8mm-evk.dts))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(BOOT_OFFSET) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx8mmini

define Device/imx8mnano
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX8MNANO
  DEVICE_VARIANT := SD Card Boot
  BOARD_NAME := iMX8MN
  SOC_TYPE := iMX8M
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_evk
  ENV_NAME:=imx8mn-sdboot
  DEVICE_PACKAGES += \
	atf-imx8mn \
	firmware-imx \
	imx-mkimage \
	u-boot-imx8mn
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx8mn-evk*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(BOOT_OFFSET) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx8mnano

define Device/imx8mquad
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX8MQUAD
  DEVICE_VARIANT := SD Card Boot
  BOARD_NAME := iMX8MQ
  SOC_TYPE := iMX8M
  BOOT_OFFSET := 33
  BOOT_TYPE := flash_evk
  ENV_NAME:=imx8mq-sdboot
  DEVICE_PACKAGES += \
	atf-imx8mq \
	firmware-imx \
	imx-mkimage \
	u-boot-imx8mq
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx8mq-evk*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(BOOT_OFFSET) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx8mquad
