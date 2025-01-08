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
	# append the kernel and dtb
	rm -fR $@.boot
	mkdir -p $@.boot
	$(foreach dts,$(DEVICE_DTS), $(CP) $(KDIR)/image-$(dts).dtb $@.boot/$(dts).dtb;)
	$(CP) $(IMAGE_KERNEL) $@.boot/$(KERNEL_NAME)
	make_ext4fs -J -L kernel -l $(IMX_SD_KERNEL_PARTSIZE)M \
		$(if $(SOURCE_DATE_EPOCH),-T $(SOURCE_DATE_EPOCH)) \
		$@.bootimg $@.boot
endef

define Build/sdcard-img-ext4
	# divide sd card into 2 partitions, kernel + rootfs
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
	dd if=$(STAGING_DIR_IMAGE)/imx-mkimage/$(1)/flash.bin of="$@" bs=1K seek=32 conv=notrunc
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

define Device/imx91evk
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx91evk
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX91
  SOC_TYPE := iMX91
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx91evk-sdboot
  DEVICE_PACKAGES += \
	atf-imx91evk \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx91evk
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx91-11x11-evk*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(SOC_TYPE) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx91evk

define Device/imx91frdm
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx91frdm
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX91
  SOC_TYPE := iMX91
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx91frdm-sdboot
  DEVICE_PACKAGES += \
	atf-imx91frdm \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx91frdm
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx91-11x11-frdm*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(SOC_TYPE) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx91frdm

define Device/imx91qsb
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx91qsb
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX91
  SOC_TYPE := iMX91
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx91qsb-sdboot
  DEVICE_PACKAGES += \
	atf-imx91qsb \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx91qsb
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx91-9x9-qsb*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(SOC_TYPE) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx91qsb

define Device/imx93evk
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx93evk
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX93
  SOC_TYPE := iMX93
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx93evk-sdboot
  DEVICE_PACKAGES += \
	atf-imx93evk \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx93evk
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx93-*-evk*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(SOC_TYPE) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx93evk

define Device/imx93frdm
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx93frdm
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX93
  SOC_TYPE := iMX93
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx93frdm-sdboot
  DEVICE_PACKAGES += \
	atf-imx93frdm \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx93frdm
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx93-11x11-frdm*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(SOC_TYPE) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx93frdm

define Device/imx93qsb
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx93qsb
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX93
  SOC_TYPE := iMX93
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx93qsb-sdboot
  DEVICE_PACKAGES += \
	atf-imx93qsb \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx93qsb
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx93-9x9-qsb*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot $$(SOC_TYPE) | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx93qsb
