# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022-2026 NXP
#
include $(TOPDIR)/rules.mk

PKG_NAME:=imx-mkimage
PKG_VERSION:=6.12.49
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/imx-mkimage.git
PKG_SOURCE_VERSION:=lf-6.12.49-2.2.0
PKG_MIRROR_HASH:=3c31a48cc7d61a72e54441bb4fd3c7c19de0735c3d11154c4c7825bbbf5909e1

PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Package/imx-mkimage
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Combine uboot and other firmware together
  BUILD_TARGET:=imx
endef

define Package/imx-mkimage/install
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
endef

define Build/Compile
endef

define Build/InstallDev
	mkdir -p $(STAGING_DIR_IMAGE)/imx-mkimage
	$(CP) $(PKG_BUILD_DIR)/* $(STAGING_DIR_IMAGE)/imx-mkimage
endef

$(eval $(call BuildPackage,imx-mkimage))
