#
# Copyright (C) 2013-2014,2024 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uboot-imx
PKG_VERSION:=lf-6.6.36-2.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/uboot-imx.git
PKG_SOURCE_VERSION:=lf-6.6.36-2.1.0
PKG_MIRROR_HASH:=a4353593d52a9adbcde3167369873fe6

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=imx
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

define U-Boot/pico-pi-imx7d
  NAME:=TechNexion PICO-PI-IMX7D
  UBOOT_IMAGE:=SPL u-boot-dtb.img
  UBOOT_MAKE_FLAGS+=SPL u-boot-dtb.img
  BUILD_SUBTARGET:=cortexa7
  BUILD_DEVICES:=technexion_imx7d-pico-pi
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/wandboard
  NAME:=Wandboard Dual Lite/Quad/Solo
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=wandboard_dual
  UBOOT_MAKE_FLAGS += u-boot.imx
  UBOOT_IMAGE:=u-boot.imx
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

define U-Boot/imx8mp
  NAME:=imx8mplus lpddr4 board
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  UBOOT_CONFIG:=imx8mp_evk
  ENV_NAME:=imx8mp-sdboot
  DTB_NAME:=imx8mp-evk.dtb
  DEPENDS:=+imx-mkimage
  ENV_SIZE:=0x4000
endef

define U-Boot/imx8mm
  NAME:=imx8mmini lpddr4 board
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  UBOOT_CONFIG:=imx8mm_evk
  ENV_NAME:=imx8mm-sdboot
  DTB_NAME:=imx8mm-evk.dtb
  DEPENDS:=+imx-mkimage
  ENV_SIZE:=0x4000
endef

define U-Boot/imx8mn
  NAME:=imx8mnano lpddr4 board
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  UBOOT_CONFIG:=imx8mn_evk
  ENV_NAME:=imx8mn-sdboot
  DTB_NAME:=imx8mn-evk.dtb
  DEPENDS:=+imx-mkimage
  ENV_SIZE:=0x4000
endef

define U-Boot/imx8mq
  NAME:=imx8mquad lpddr4 board
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  UBOOT_CONFIG:=imx8mq_evk
  ENV_NAME:=imx8mq-sdboot
  DTB_NAME:=imx8mq-evk.dtb
  DEPENDS:=+imx-mkimage
  ENV_SIZE:=0x4000
endef

define U-Boot/imx93
  BUILD_DEVICES:=imx93
  NAME:=imx93evk board
  UBOOT_CONFIG:=imx93_11x11_evk
  ENV_NAME:=imx93-sdboot
  DTB_NAME:=imx93-11x11-evk.dtb
  ENV_SIZE:=0x4000
  BUILD_SUBTARGET:=cortexa55
  DEPENDS:=@TARGET_imx_cortexa55
endef

UBOOT_TARGETS := \
	apalis_imx6 \
	mx6cuboxi \
	pico-pi-imx7d \
	wandboard \
	imx6ull \
	imx8mp \
	imx8mm \
	imx8mn \
	imx8mq \
	imx93

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
ifeq ($(SUBTARGET),imx8)
	$(CP) $(PKG_BUILD_DIR)/u-boot-nodtb.bin \
		$(PKG_BUILD_DIR)/spl/u-boot-spl.bin \
		$(PKG_BUILD_DIR)/arch/arm/dts/$(DTB_NAME) \
		$(STAGING_DIR_IMAGE)/imx-mkimage/iMX8M
	$(CP) $(PKG_BUILD_DIR)/tools/mkimage \
		$(STAGING_DIR_IMAGE)/imx-mkimage/iMX8M/mkimage_uboot
else ifeq ($(SUBTARGET),cortexa55)
	$(CP) $(PKG_BUILD_DIR)/u-boot.bin \
		$(PKG_BUILD_DIR)/spl/u-boot-spl.bin \
		$(STAGING_DIR_IMAGE)/imx-mkimage/iMX93
endif

ifneq ($(UBOOT_IMAGE),)
	$(foreach img,$(UBOOT_IMAGE), \
		$(CP) $(PKG_BUILD_DIR)/$(img) $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-$(img); \
	)
endif

ifneq ($(ENV_NAME),)
	$(PKG_BUILD_DIR)/tools/mkenvimage -s $(ENV_SIZE) \
		-o $(STAGING_DIR_IMAGE)/$(ENV_NAME)-uboot-env.bin \
		files/$(ENV_NAME)-uEnv.txt
endif
endef

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
