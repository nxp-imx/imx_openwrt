#
# Copyright (C) 2013-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uboot-imx
PKG_VERSION:=lf-5.15.5-1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://source.codeaurora.org/external/imx/uboot-imx
PKG_SOURCE_VERSION:=lf-5.15.5-1.0.0
PKG_MIRROR_HASH:=fdb2086a1182b2c96e8c8dcfb795f004

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=imx
  UBOOT_IMAGE:=u-boot.imx
endef

define U-Boot/apalis_imx6
  NAME:=Toradex Apalis
  UBOOT_IMAGE:=SPL u-boot.img u-boot-with-spl.imx
  UBOOT_MAKE_FLAGS+=SPL u-boot.img u-boot-with-spl.imx
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=toradex_apalis
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/mx6cuboxi
  NAME:=SolidRun Cubox-i boards
  UBOOT_IMAGE:=SPL u-boot-dtb.img
  UBOOT_MAKE_FLAGS+=SPL u-boot-dtb.img
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=solidrun_cubox-i
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/wandboard
  NAME:=Wandboard Dual Lite/Quad/Solo
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=wandboard_dual
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/imx8mp
  NAME:=imx8mplus lpddr4 board
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  UBOOT_CONFIG:=imx8mp_evk
  ENV_NAME:=imx8mp-sdboot
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
  DTB_NAME:=imx8mp-evk.dtb
  DEPENDS:=+imx-mkimage
  ENV_SIZE:=0x4000
endef

UBOOT_TARGETS := \
	apalis_imx6 \
	mx6cuboxi \
	wandboard \
	imx8mp

ifeq ($(SUBTARGET),imx8)
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
else
define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(foreach img,$(UBOOT_IMAGE), \
		$(CP) $(PKG_BUILD_DIR)/$(img) $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-$(img); \
	)
endef
endif

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
