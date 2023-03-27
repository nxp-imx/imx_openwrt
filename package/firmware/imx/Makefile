# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=firmware-imx
PKG_VERSION:=5.15.32
PKG_RELEASE:=1

FIRMWARE_URL:=https://www.nxp.com/lgfiles/NMG/MAD/YOCTO/
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk

FIRMWARE_IMX:=firmware-imx-8.17
FIRMWARE_IMX_BIN:=$(FIRMWARE_IMX).bin
define Download/firmware-imx
  URL:=$(FIRMWARE_URL)
  FILE:=$(FIRMWARE_IMX_BIN)
  HASH:=63eac7b400d711c668458ec4bf5d0c60
endef

FIRMWARE_SENTINEL:=firmware-sentinel-0.5.1
FIRMWARE_SENTINEL_BIN:=$(FIRMWARE_SENTINEL).bin
define Download/firmware-sentinel
  URL:=$(FIRMWARE_URL)
  FILE:=$(FIRMWARE_SENTINEL_BIN)
  HASH:=8bf928be9bd9a59d5cfb2cd6441c91b8
endef

define Build/Prepare
	# Download sources
	$(eval $(call Download,firmware-imx))
	$(eval $(call Download,firmware-sentinel))
	$(call Build/Prepare/Default,)
endef

define Package/firmware-imx
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=NXP firmware for imx soc
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX9
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=cortexa53
  DEPENDS:=+imx-mkimage
endef

UNPACK_CMD:=
define Package/firmware-imx/install
endef

define Build/Compile
endef

define Build/Install
endef

define Build/InstallDev
	$(PKG_UNPACK)
	$(CP) $(DL_DIR)/$(FIRMWARE_IMX_BIN) $(PKG_BUILD_DIR)
	chmod a+x $(PKG_BUILD_DIR)/$(FIRMWARE_IMX_BIN)
	cd $(PKG_BUILD_DIR) && ./$(FIRMWARE_IMX_BIN) --auto-accept
	$(CP) $(PKG_BUILD_DIR)/$(FIRMWARE_IMX)/firmware/ddr/synopsys/* \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)

	$(CP) $(DL_DIR)/$(FIRMWARE_SENTINEL_BIN) $(PKG_BUILD_DIR)
	chmod a+x $(PKG_BUILD_DIR)/$(FIRMWARE_SENTINEL_BIN)
	cd $(PKG_BUILD_DIR) && ./$(FIRMWARE_SENTINEL_BIN) --auto-accept
	$(CP) $(PKG_BUILD_DIR)/$(FIRMWARE_SENTINEL)/* \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
endef

$(eval $(call BuildPackage,firmware-imx))
