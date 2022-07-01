# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=firmware-imx
PKG_VERSION:=8.15
PKG_RELEASE:=1

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).bin
PKG_SOURCE_URL:=https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/
PKG_HASH:=ef91390da6c8a6a48c8121a5dd667de8

include $(INCLUDE_DIR)/package.mk

define Package/firmware-imx
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=NXP firmware for imx soc
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  DEPENDS:=+imx-mkimage
endef

define Package/firmware-imx/install
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

$(eval $(call BuildPackage,firmware-imx))
