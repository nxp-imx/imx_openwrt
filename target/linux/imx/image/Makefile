# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2013 OpenWrt.org

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

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
	cd $(STAGING_DIR_IMAGE)/imx-mkimage && $(MAKE) SOC=$(1) $(2)
endef

define Build/imx-append
	# append binary
	dd if=$(STAGING_DIR_IMAGE)/$(1) >> $@
endef

define Build/imx-append-boot
	# Append the uboot, firmware etc.
	dd if=$(STAGING_DIR_IMAGE)/imx-mkimage/$(1)/flash.bin >> $@
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

include $(SUBTARGET).mk

$(eval $(call BuildImage))
