#
# Copyright (C) 2013-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uboot-imx
PKG_VERSION:=22.04
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/uboot-imx.git
PKG_SOURCE_VERSION:=imx_5.15.32_imx93_er1

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

define U-Boot/imx6ull
  NAME:=imx6ultra lite board
  BUILD_SUBTARGET:=cortexa7
  BUILD_DEVICES:=imx6ull
  UBOOT_CONFIG:=mx6ull_14x14_evk
  ENV_SIZE:=0x2000
  ENV_NAME:=imx6ull-sdboot
  DTB_NAME:=imx6ull-14x14-evk
  UBOOT_IMAGE:=u-boot-dtb.imx
endef

define U-Boot/wandboard
  NAME:=Wandboard Dual Lite/Quad/Solo
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=wandboard_dual
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/imx8mp
  BUILD_SUBTARGET:=cortexa53
  BUILD_DEVICES:=imx8mplus
  NAME:=imx8mplus lpddr4 board
  UBOOT_CONFIG:=imx8mp_evk
  ENV_NAME:=imx8mp-sdboot
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
  DTB_NAME:=imx8mp-evk.dtb
  ENV_SIZE:=0x4000
  DEPENDS:=@TARGET_imx_cortexa53
endef

define U-Boot/imx8mm
  BUILD_SUBTARGET:=cortexa53
  BUILD_DEVICES:=imx8mmini
  NAME:=imx8mmini lpddr4 board
  UBOOT_CONFIG:=imx8mm_evk
  ENV_NAME:=imx8mm-sdboot
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
  DTB_NAME:=imx8mm-evk.dtb
  ENV_SIZE:=0x1000
  DEPENDS:=@TARGET_imx_cortexa53
endef

define U-Boot/imx93
  BUILD_SUBTARGET:=cortexa53
  BUILD_DEVICES:=imx93
  NAME:=imx8mmini lpddr4 board
  UBOOT_CONFIG:=imx93_11x11_evk
  ENV_NAME:=imx93-sdboot
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX9
  DTB_NAME:=imx93-11x11-evk.dtb
  ENV_SIZE:=0x4000
  DEPENDS:=@TARGET_imx_cortexa53
endef

UBOOT_TARGETS := \
	apalis_imx6 \
	mx6cuboxi \
	imx6ull \
	wandboard \
	imx8mp \
	imx8mm \
	imx93

ifeq ($(SUBTARGET),cortexa53)
define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/u-boot.bin \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
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
    ifneq ($(ENV_NAME),)
		$(PKG_BUILD_DIR)/tools/mkenvimage -s $(ENV_SIZE) \
			-o $(STAGING_DIR_IMAGE)/$(ENV_NAME)-uboot-env.bin \
			files/$(ENV_NAME)-uEnv.txt
    endif
endef
endif

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
