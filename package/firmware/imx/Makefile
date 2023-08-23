# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=fw-imx
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

FIRMWARE_SENTINEL:=firmware-sentinel-0.5.1
FIRMWARE_SENTINEL_BIN:=$(FIRMWARE_SENTINEL).bin
define Download/firmware-sentinel
  URL:=$(FIRMWARE_URL)
  FILE:=$(FIRMWARE_SENTINEL_BIN)
  HASH:=a4f249feef325fee59a67551d704511014fb5cf766b9ecaa4ba7d2a916056222
endef
$(eval $(call Download,firmware-sentinel))

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
		$(PKG_BUILD_DIR)/$(FIRMWARE_IMX)/firmware/sdma/* \
		$(1)/lib/firmware/imx/sdma/
endef

define Package/firmware-imx
  $(Package/fw-default)
  TITLE:=NXP firmware for imx8/9
  DEPENDS:=+imx-mkimage
endef

define Package/firmware-imx/install
	$(INSTALL_DIR) $(1)/lib/firmware/imx/sdma
ifeq ($(SUBTARGET),imx8)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(FIRMWARE_IMX)/firmware/ddr/synopsys/* \
		$(STAGING_DIR_IMAGE)/imx-mkimage/iMX8M
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/$(FIRMWARE_IMX)/firmware/sdma/sdma-imx7d.bin \
		$(1)/lib/firmware/imx/sdma
else ifeq ($(SUBTARGET),cortexa55)
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/$(FIRMWARE_IMX)/firmware/ddr/synopsys/* \
		$(STAGING_DIR_IMAGE)/imx-mkimage/iMX9
endif
endef

define Package/firmware-sentinel
  $(Package/fw-default)
  TITLE:=NXP firmware for imx9
  DEPENDS:=+imx-mkimage
endef

define Package/firmware-sentinel/install
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)/imx-mkimage/iMX9
	$(INSTALL_DATA) \
		$(PKG_BUILD_DIR)/$(FIRMWARE_SENTINEL)/* \
		$(STAGING_DIR_IMAGE)/imx-mkimage/iMX9
endef

UNPACK_CMD:=
define Build/Prepare
	$(PKG_UNPACK)
	$(CP) $(DL_DIR)/$(FIRMWARE_IMX_BIN) $(PKG_BUILD_DIR)
	chmod a+x $(PKG_BUILD_DIR)/$(FIRMWARE_IMX_BIN)
	cd $(PKG_BUILD_DIR) && ./$(FIRMWARE_IMX_BIN) --auto-accept

	$(CP) $(DL_DIR)/$(FIRMWARE_SENTINEL_BIN) $(PKG_BUILD_DIR)
	chmod a+x $(PKG_BUILD_DIR)/$(FIRMWARE_SENTINEL_BIN)
	cd $(PKG_BUILD_DIR) && ./$(FIRMWARE_SENTINEL_BIN) --auto-accept
endef

define Build/Compile
endef

define Build/InstallDev
endef

$(eval $(call BuildPackage,firmware-sdma))
$(eval $(call BuildPackage,firmware-imx))
$(eval $(call BuildPackage,firmware-sentinel))
