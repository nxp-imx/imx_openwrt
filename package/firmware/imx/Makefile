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

FIRMWARE_IMX:=firmware-imx-8.17
FIRMWARE_IMX_BIN:=$(FIRMWARE_IMX).bin
define Download/firmware-imx
  URL:=$(PKG_SOURCE_URL)
  FILE:=$(FIRMWARE_IMX_BIN)
  HASH:=63eac7b400d711c668458ec4bf5d0c60
endef

define Package/firmware-imx
  SECTION:=firmware
  CATEGORY:=Firmware
  TITLE:=NXP firmware for imx soc
  BUILD_TARGET:=imx
endef

UNPACK_CMD:=
define Package/firmware-imx/install
	$(if $(CONFIG_TARGET_imx_cortexa7),
		$(INSTALL_DIR) $(1)/lib/firmware/imx/sdma
		$(INSTALL_DATA) \
			$(PKG_BUILD_DIR)/firmware-imx-8.15/firmware/sdma/sdma-imx6q.bin \
			$(1)/lib/firmware/imx/sdma/ )
	$(if $(CONFIG_TARGET_imx_imx8),
		$(CP) $(PKG_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)/firmware/ddr/synopsys/* \
			$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
		$(CP) $(PKG_BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)/firmware/hdmi/cadence/* \
			$(STAGING_DIR_IMAGE)/$(MKIMG_DIR) )
endef

define Build/Prepare
	# Download sources
	$(eval $(call Download,firmware-imx))
	$(call Build/Prepare/Default,)

	$(PKG_UNPACK)
	$(CP) $(DL_DIR)/$(PKG_SOURCE) $(PKG_BUILD_DIR)
	chmod a+x $(PKG_BUILD_DIR)/$(PKG_SOURCE)
	cd $(PKG_BUILD_DIR) && ./$(PKG_SOURCE) --auto-accept
endef

define Build/Compile
endef

define Build/Install
endef

define Build/InstallDev
endef

$(eval $(call BuildPackage,firmware-imx))
