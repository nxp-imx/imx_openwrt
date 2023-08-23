# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#
include $(TOPDIR)/rules.mk

PKG_NAME:=imx-mkimage
PKG_VERSION:=lf-5.15.71-2.2.1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/imx-mkimage.git
PKG_SOURCE_VERSION:=lf-5.15.71-2.2.1
PKG_MIRROR_HASH:=40df71bda4dbcf9a3782cf55b51630d076ec3fcf7bb11e338e97fc808b0df730

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
	mkdir -p $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR) $(STAGING_DIR_IMAGE)/imx-mkimage
endef

$(eval $(call BuildPackage,imx-mkimage))
