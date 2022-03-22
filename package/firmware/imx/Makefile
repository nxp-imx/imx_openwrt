# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=firmware-imx
PKG_VERSION:=8.10
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).bin
PKG_SOURCE_URL:=https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/
PKG_HASH:=2b70f169d4065b2a7ac7a676afe24636128bd2dacc9f5230346758c3b146b2be

include $(INCLUDE_DIR)/package.mk

define Package/firmware-imx
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=NXP MC firmware
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  DEPENDS:=+imx-mkimage
endef

define Build/Compile
endef

define Build/Install
endef

UNPACK_CMD:=
define Build/InstallDev
	$(PKG_UNPACK)
	$(CP) $(DL_DIR)/$(PKG_SOURCE) $(PKG_BUILD_DIR)
	chmod a+x $(PKG_BUILD_DIR)/$(PKG_SOURCE)
	cd $(PKG_BUILD_DIR) && ./$(PKG_SOURCE) --auto-accept
	$(CP) $(PKG_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)/firmware/ddr/synopsys/* \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
endef

define Package/firmware-imx/install
endef

$(eval $(call BuildPackage,firmware-imx))
