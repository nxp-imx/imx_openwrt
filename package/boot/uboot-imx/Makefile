# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uboot-imx
PKG_VERSION:=imx_v2020.04_5.4.70_2.3.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://source.codeaurora.org/external/imx/uboot-imx
PKG_SOURCE_VERSION:=imx_v2020.04_5.4.70_2.3.0
PKG_MIRROR_HASH:=874e871755ef84ebbf35cc247f0979ec18ed1946e4dca71006a83463b2899db1

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=imx6
  BUILD_DEVICES:=$(1)
endef

define U-Boot/apalis_imx6
  NAME:=Toradex Apalis
  UBOOT_IMAGE:=SPL u-boot.img u-boot-with-spl.imx
  UBOOT_MAKE_FLAGS:=SPL u-boot.img u-boot-with-spl.imx
  BUILD_DEVICES:=apalis
endef

define U-Boot/mx6cuboxi
  NAME:=SolidRun Cubox-i boards
  UBOOT_IMAGE:=SPL u-boot.img
  UBOOT_MAKE_FLAGS:=SPL u-boot.img
  BUILD_DEVICES:=cubox-i
  HIDDEN:=1
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/mx6sabresd
  NAME:=SABRE i.MX6Quad board
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/nitrogen6dl
  NAME:=Nitrogen6x i.MX6Dual-Lite 1GB board
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/nitrogen6dl2g
  NAME:=Nitrogen6x i.MX6Dual-Lite 2GB board
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/nitrogen6q
  NAME:=Nitrogen6x/SABRE Lite (MX6Q/1GB)
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/nitrogen6q2g
  NAME:=Nitrogen6x i.MX6Quad 2GB board
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/nitrogen6s
  NAME:=Nitrogen6x i.MX6Solo 512MB board
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/nitrogen6s1g
  NAME:=Nitrogen6x i.MX6Solo 1GB board
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/wandboard
  NAME:=Wandboard Dual Lite/Quad/Solo
  UBOOT_MAKE_FLAGS += u-boot.imx
  BUILD_DEVICES:=wandboard
endef

define U-Boot/imx8mp
  NAME:=imx8mplus ddr4 board
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  UBOOT_CONFIG:=imx8mp_evk
  ENV_NAME:=imx8mp-sdboot
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
  DTB_NAME:=imx8mp-evk.dtb
  DEPENDS:=+imx-mkimage
  ENV_SIZE:=4096
endef

UBOOT_TARGETS := \
	apalis_imx6 \
	mx6cuboxi \
	mx6sabresd \
	nitrogen6dl \
	nitrogen6dl2g \
	nitrogen6q \
	nitrogen6q2g \
	nitrogen6s \
	nitrogen6s1g \
	wandboard \
	imx8mp

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/u-boot-nodtb.bin \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
	$(CP) $(PKG_BUILD_DIR)/spl/u-boot-spl.bin \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
	$(CP) $(PKG_BUILD_DIR)/arch/arm/dts/$(DTB_NAME) \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
	$(CP) $(PKG_BUILD_DIR)/tools/mkimage \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)/mkimage_uboot
	$(PKG_BUILD_DIR)/tools/mkenvimage -s $(ENV_SIZE) \
		-o $(STAGING_DIR_IMAGE)/$(ENV_NAME)-uboot-env.bin \
		files/$(ENV_NAME)-uEnv.txt
endef

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
