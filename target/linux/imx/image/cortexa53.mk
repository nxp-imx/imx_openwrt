# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024-2025 OpenWrt.org

IMX_SD_KERNEL_PARTSIZE = 64
DEVICE_VARS += IMX_UBOOT_DTB BOOT_OFFSET IMX_MKIMAGE_EXTRA IMX_OEI_BOARD

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
	$(foreach dtbo,$(DEVICE_DTS_OVERLAY), $(CP) $(KDIR)/image-$(dtbo).dtbo $@.boot/$(dtbo).dtbo;)
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
	# imx-mkimage's flash_evk target (i.MX 8M) defaults to <plat>-evk.dtb.
	# Boards whose u-boot DTB differs (e.g. the FRDM boards) set
	# IMX_UBOOT_DTB to override it via the dtbs= variable. The override is
	# only meaningful for flash_evk; other boot types (e.g. the i.MX 9
	# flash_singleboot flow) embed the DTB in u-boot.bin and ignore dtbs=.
	cd $(STAGING_DIR_IMAGE)/imx-mkimage && $(MAKE) SOC=$(1) $(2) \
		$(if $(filter flash_evk,$(2)),$(if $(IMX_UBOOT_DTB),dtbs=$(IMX_UBOOT_DTB)))
endef

define Build/imx95-select-oei
	# i.MX95 flash_a55 consumes a single oei-m33-ddr.bin from the iMX95 dir.
	# The imx-oei package installs a per-board variant (oei-m33-ddr-<board>.bin);
	# copy the one that matches this device into place before building flash.bin.
	$(CP) $(STAGING_DIR_IMAGE)/imx-mkimage/iMX95/oei-m33-ddr-$(IMX_OEI_BOARD).bin \
		$(STAGING_DIR_IMAGE)/imx-mkimage/iMX95/oei-m33-ddr.bin
endef

define Build/imx95-create-flash
	# Build i.MX95 flash.bin using imx-mkimage's flash_a55 target (ELE +
	# System Manager m33_image + OEI DDR firmware + ATF container + SPL +
	# U-Boot). The M7 demo image is intentionally omitted (flash_a55 instead
	# of flash_all) as it is not needed to boot Linux on the A55 cores.
	# Per-variant flags (REV/OEI/LPDDR_TYPE) come from IMX_MKIMAGE_EXTRA.
	rm -rf $@.xxdbin && mkdir -p $@.xxdbin
	real_xxd="$$(PATH=/usr/bin:/bin:$$PATH command -v xxd)"; \
		[ -n "$$real_xxd" ] || { echo "real xxd (vim-common) not found; needed for i.MX95 fw-header"; exit 1; }; \
		ln -sf "$$real_xxd" $@.xxdbin/xxd
	cd $(STAGING_DIR_IMAGE)/imx-mkimage && export PATH="$@.xxdbin:$$PATH" && \
		$(MAKE) SOC=iMX95 $(IMX_MKIMAGE_EXTRA) flash_a55
	rm -rf $@.xxdbin
endef

define Build/imx-append-env
	# append env binary
	dd if=$(STAGING_DIR_IMAGE)/$(1) of="$@" bs=1M seek=7 conv=notrunc
endef

define Build/imx-append-boot
	# Append the uboot, firmware etc.
	# The bootloader offset on the SD card depends on the SoC (see the i.MX
	# Linux User's Guide UG10163): 33 KB for i.MX 8M Quad/Mini, 32 KB for
	# i.MX 8M Plus/Nano and i.MX 9. Each device sets it via BOOT_OFFSET.
	dd if=$(STAGING_DIR_IMAGE)/imx-mkimage/$(1)/flash.bin of="$@" bs=1K seek=$(BOOT_OFFSET) conv=notrunc
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
	imx-append-boot iMX8M | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx8mplus

define Device/imx8mpfrdm
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX8MPLUS
  DEVICE_VARIANT := FRDM SD Card Boot
  BOARD_NAME := iMX8MP
  SOC_TYPE := iMX8M
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_evk
  ENV_NAME:=imx8mpfrdm-sdboot
  IMX_UBOOT_DTB := imx8mp-frdm.dtb
  DEVICE_PACKAGES += \
	atf-imx8mp \
	firmware-imx \
	imx-mkimage \
	u-boot-imx8mpfrdm \
	kmod-mwifiex-iw612-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx8mp-frdm.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX8M | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx8mpfrdm

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
	imx-append-boot iMX8M | \
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
	imx-append-boot iMX8M | \
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
	imx-append-boot iMX8M | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx8mquad

define Device/imx91evk
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx91evk
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX91
  SOC_TYPE := iMX91
  BOOT_OFFSET := 32
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
	imx-append-boot iMX91 | \
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
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx91frdm-sdboot
  DEVICE_PACKAGES += \
	atf-imx91frdm \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx91frdm \
	kmod-mwifiex-iw610-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx91-11x11-frdm*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX91 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx91frdm

define Device/imx91frdm-imx91s
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx91frdm
  DEVICE_VARIANT := IMX91S SD Boot
  BOARD_NAME := iMX91
  SOC_TYPE := iMX91
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx91frdm-imx91s-sdboot
  DEVICE_PACKAGES += \
	atf-imx91frdm-imx91s \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx91frdm-imx91s
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx91-11x11-frdm-imx91s*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX91 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx91frdm-imx91s

define Device/imx91qsb
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx91qsb
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX91
  SOC_TYPE := iMX91
  BOOT_OFFSET := 32
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
	imx-append-boot iMX91 | \
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
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx93evk-sdboot
  DEVICE_PACKAGES += \
	atf-imx93evk \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx93evk \
	kmod-mwifiex-iw612-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx93-*-evk*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX93 | \
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
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx93frdm-sdboot
  DEVICE_PACKAGES += \
	atf-imx93frdm \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx93frdm \
	kmod-mwifiex-iw612-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := $(basename $(notdir $(wildcard $(DTS_DIR)/freescale/imx93-11x11-frdm*.dts)))
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX93 | \
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
  BOOT_OFFSET := 32
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
	imx-append-boot iMX93 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx93qsb

define Device/imx93wevk
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx93wevk
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX93
  SOC_TYPE := iMX93
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx93wevk-sdboot
  DEVICE_PACKAGES += \
	atf-imx93wevk \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx93wevk \
	kmod-mwifiex-iw610-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := imx93w-evk
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX93 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx93wevk

define Device/imx93wfrdm
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx93wfrdm
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX93
  SOC_TYPE := iMX93
  BOOT_OFFSET := 32
  BOOT_TYPE := flash_singleboot
  ENV_NAME:=imx93wfrdm-sdboot
  DEVICE_PACKAGES += \
	atf-imx93wfrdm \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	u-boot-imx93wfrdm \
	kmod-mwifiex-iw610-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := imx93w-frdm
  IMAGE/sdcard.img := \
	imx-clean | \
	imx-create-flash $$(BOARD_NAME) $$(BOOT_TYPE) | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX93 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx93wfrdm

define Device/imx95_15x15_evk
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx95evk
  DEVICE_VARIANT := 15x15 SD Boot
  BOARD_NAME := iMX95
  SOC_TYPE := iMX95
  BOOT_OFFSET := 32
  ENV_NAME:=imx95_15x15_evk-sdboot
  IMX_OEI_BOARD := mx95lp4x-15
  IMX_MKIMAGE_EXTRA := REV=B0 OEI=YES LPDDR_TYPE=lpddr4x
  DEVICE_PACKAGES += \
	atf-imx95_15x15_evk \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	imx-oei \
	imx-sm \
	u-boot-imx95_15x15_evk \
	kmod-mwifiex-iw612-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := imx95-15x15-evk
  IMAGE/sdcard.img := \
	imx-clean | \
	imx95-select-oei | \
	imx95-create-flash | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX95 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx95_15x15_evk

define Device/imx95_19x19_evk
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx95evk
  DEVICE_VARIANT := 19x19 SD Boot
  BOARD_NAME := iMX95
  SOC_TYPE := iMX95
  BOOT_OFFSET := 32
  ENV_NAME:=imx95_19x19_evk-sdboot
  IMX_OEI_BOARD := mx95lp5
  IMX_MKIMAGE_EXTRA := REV=B0 OEI=YES
  DEVICE_PACKAGES += \
	atf-imx95_19x19_evk \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	imx-oei \
	imx-sm \
	u-boot-imx95_19x19_evk
  DEVICE_DTS := imx95-19x19-evk
  IMAGE/sdcard.img := \
	imx-clean | \
	imx95-select-oei | \
	imx95-create-flash | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX95 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx95_19x19_evk

define Device/imx95frdm
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx95frdm
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX95
  SOC_TYPE := iMX95
  BOOT_OFFSET := 32
  ENV_NAME:=imx95frdm-sdboot
  IMX_OEI_BOARD := mx95lp4x-15
  IMX_MKIMAGE_EXTRA := REV=B0 OEI=YES LPDDR_TYPE=lpddr4x
  DEVICE_PACKAGES += \
	atf-imx95frdm \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	imx-oei \
	imx-sm \
	u-boot-imx95frdm \
	kmod-mwifiex-iw612-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := imx95-15x15-frdm
  IMAGE/sdcard.img := \
	imx-clean | \
	imx95-select-oei | \
	imx95-create-flash | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX95 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx95frdm

define Device/imx95frdmpro
  $(call Device/Default)
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := imx95frdmpro
  DEVICE_VARIANT := SD Boot
  BOARD_NAME := iMX95
  SOC_TYPE := iMX95
  BOOT_OFFSET := 32
  ENV_NAME:=imx95frdmpro-sdboot
  IMX_OEI_BOARD := mx95lp5
  IMX_MKIMAGE_EXTRA := REV=B0 OEI=YES
  DEVICE_PACKAGES += \
	atf-imx95frdmpro \
	firmware-imx \
	firmware-sentinel \
	imx-mkimage \
	imx-oei \
	imx-sm \
	u-boot-imx95frdmpro \
	kmod-mwifiex-iw612-sdio \
	wireless-tools \
	wpa-supplicant-openssl
  DEVICE_DTS := imx95-19x19-frdm-pro
  IMAGE/sdcard.img := \
	imx-clean | \
	imx95-select-oei | \
	imx95-create-flash | \
	boot-img-ext4 | \
	sdcard-img-ext4 | \
	imx-append-boot iMX95 | \
	imx-append-env $$(ENV_NAME)-uboot-env.bin
endef
TARGET_DEVICES += imx95frdmpro
