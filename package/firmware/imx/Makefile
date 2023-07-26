# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=firmware-imx
PKG_RELEASE:=1

FIRMWARE_URL:=https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/

include $(INCLUDE_DIR)/package.mk

FIRMWARE_IMX:=firmware-imx-8.18
FIRMWARE_IMX_BIN:=$(FIRMWARE_IMX).bin
define Download/firmware-imx
  URL:=$(FIRMWARE_URL)
  FILE:=$(FIRMWARE_IMX_BIN)
  HASH:=f050f60351a54fd75954fdeb133ddd014a5576040c72616e216b63db0e242dd4
endef
$(eval $(call Download,firmware-imx))

define Package/fw-default
  SECTION:=firmware
  CATEGORY:=Firmware
  BUILD_TARGET:=imx
endef

define Package/firmware-sdma
  $(Package/fw-default)
  TITLE:=NXP firmware for imx cortexa7 SOC
  BUILD_SUBTARGET:=cortexa7
endef

define Package/firmware-sdma/install
	$(INSTALL_DIR) $(1)/lib/firmware/imx/sdma
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/$(FIRMWARE_IMX)/firmware/sdma/sdma-imx6q.bin \
		$(1)/lib/firmware/imx/sdma/
endef

define Package/firmware-imx
  $(Package/fw-default)
  TITLE:=NXP firmware for imx8
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
  BUILD_SUBTARGET:=imx8
  DEPENDS:=@CONFIG_PACKAGE_imx-mkimage
endef

define Package/firmware-imx/install
	$(CP) $(PKG_BUILD_DIR)/$(FIRMWARE_IMX)/firmware/ddr/synopsys/* \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
endef

UNPACK_CMD:=
define Build/Prepare
	$(PKG_UNPACK)
	$(CP) $(DL_DIR)/$(FIRMWARE_IMX_BIN) $(PKG_BUILD_DIR)
	chmod a+x $(PKG_BUILD_DIR)/$(FIRMWARE_IMX_BIN)
	cd $(PKG_BUILD_DIR) && ./$(FIRMWARE_IMX_BIN) --auto-accept
endef

define Build/Compile
endef

$(eval $(call BuildPackage,firmware-sdma))
$(eval $(call BuildPackage,firmware-imx))
