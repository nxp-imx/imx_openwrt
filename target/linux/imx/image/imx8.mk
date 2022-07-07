# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP

# 16MB bootloader + 40MB kernel
IMX_SD_KERNELPART_SIZE = 40
IMX_SD_KERNELPART_OFFSET = 16
IMX_SD_ROOTFSPART_OFFSET = 64
IMX_SD_IMAGE_SIZE = $(shell echo $$((($(IMX_SD_ROOTFSPART_OFFSET) + \
	$(CONFIG_TARGET_ROOTFS_PARTSIZE)))))

define Build/imx-clean
	# Clean the target
	rm -f $@
endef

define Build/imx-compile-dtb
	# Compile dts file to dtb
	$(call Image/BuildDTB,$(DTS_DIR)/$(1).dts,$(DTS_DIR)/$(1).dtb)
endef

define Build/imx-create-flash
	# Combile firmware + bl31 + uboot to flash.bin
	cd $(STAGING_DIR_IMAGE)/$(MKIMG_DIR) && $(MAKE) SOC=$(1) $(2)
endef

define Build/imx-append
	# append binary
	dd if=$(STAGING_DIR_IMAGE)/$(1) >> $@
endef

define Build/imx-append-boot
	# Append the uboot, firmware etc.
	dd if=$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)/$(1)/flash.bin >> $@
endef

define Build/imx-append-dtb
	# Append the dtb file
	dd if=$(DTS_DIR)/$(1).dtb >> $@
endef

define Build/imx-append-kernel
	# append the kernel
	mkdir -p $@.tmp && \
	cp $(IMAGE_KERNEL) $@.tmp && \
	cp $(DTS_DIR)/$(1).dtb $@.tmp && \
	make_ext4fs -J -L kernel -l "$(IMX_SD_KERNELPART_SIZE)M" "$@.kernel.part" "$@.tmp" && \
	dd if=$@.kernel.part >> $@ && \
	rm -rf $@.tmp && \
	rm -f $@.kernel.part
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
  FILESYSTEMS := squashfs
  KERNEL_INITRAMFS = kernel-bin
  KERNEL_LOADADDR := 0x80080000
  KERNEL_ENTRY_POINT := 0x80080000
  IMAGE_SIZE := 64m
  KERNEL = kernel-bin
  IMAGES := sdcard.img sysupgrade.bin
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef

define Device/imx8mplus
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX8MPLUS
  DEVICE_VARIANT := SD Card Boot
  PLAT := iMX8MP
  SOC_TYPE := iMX8M
  DEVICE_TYPE := flash_evk
  ENV_NAME:=imx8mp-sdboot
  MKIMG_DIR:= `find $(STAGING_DIR_IMAGE) -name imx-mkimage* | xargs basename`
  DEVICE_PACKAGES += \
	atf-imx8mp \
	firmware-imx \
	imx-mkimage \
	u-boot-imx8mp
  DEVICE_DTS := freescale/imx8mp-evk
  IMAGE/sdcard.img := \
	imx-compile-dtb $$(DEVICE_DTS) | \
	imx-create-flash $$(PLAT) $$(DEVICE_TYPE) | \
	imx-clean | \
	imx-append-sdhead $(1) | pad-to 32K | \
	imx-append-boot $$(SOC_TYPE) | pad-to 4M | \
	imx-append $$(ENV_NAME)-uboot-env.bin | pad-to $(IMX_SD_KERNELPART_OFFSET)M | \
	imx-append-kernel $$(DEVICE_DTS) | pad-to $(IMX_SD_ROOTFSPART_OFFSET)M | \
	append-rootfs | pad-to $(IMX_SD_IMAGE_SIZE)M
endef
TARGET_DEVICES += imx8mplus

define Device/imx8mmini
  DEVICE_VENDOR := NXP
  DEVICE_MODEL := IMX8MMINI
  DEVICE_VARIANT := SD Card Boot
  PLAT := iMX8MM
  SOC_TYPE := iMX8M
  DEVICE_TYPE := flash_evk
  ENV_NAME:=imx8mm-sdboot
  MKIMG_DIR:= `find $(STAGING_DIR_IMAGE) -name imx-mkimage* | xargs basename`
  DEVICE_PACKAGES += \
	atf-imx8mm \
	firmware-imx \
	imx-mkimage \
	u-boot-imx8mm
  DEVICE_DTS := freescale/imx8mm-evk
  IMAGE/sdcard.img := \
	imx-compile-dtb $$(DEVICE_DTS) | \
	imx-create-flash $$(PLAT) $$(DEVICE_TYPE) | \
	imx-clean | \
	imx-append-sdhead $(1) | pad-to 33K | \
	imx-append-boot $$(SOC_TYPE) | pad-to 4M | \
	imx-append $$(ENV_NAME)-uboot-env.bin | pad-to $(IMX_SD_KERNELPART_OFFSET)M | \
	imx-append-kernel $$(DEVICE_DTS) | pad-to $(IMX_SD_ROOTFSPART_OFFSET)M | \
	append-rootfs | pad-to $(IMX_SD_IMAGE_SIZE)M
endef
TARGET_DEVICES += imx8mmini
