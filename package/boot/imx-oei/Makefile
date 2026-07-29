# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2026 NXP

include $(TOPDIR)/rules.mk

PKG_NAME:=imx-oei
PKG_VERSION:=6.12.49
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/imx-oei.git
PKG_SOURCE_VERSION:=lf-6.12.49-2.2.0
PKG_MIRROR_HASH:=skip

PKG_FLAGS:=nonshared

# Bare-metal M33 toolchain (must match the NXP BSP / flexbuild version exactly)
M33_TC_VERSION:=14.2.rel1
M33_TC_NAME:=arm-gnu-toolchain-$(M33_TC_VERSION)-x86_64-arm-none-eabi
M33_TC_FILE:=$(M33_TC_NAME).tar.xz
M33_TC_URL:=https://developer.arm.com/-/media/Files/downloads/gnu/$(M33_TC_VERSION)/binrel/

define Download/m33-toolchain
  URL:=$(M33_TC_URL)
  FILE:=$(M33_TC_FILE)
  HASH:=62a63b981fe391a9cbad7ef51b17e49aeaa3e7b0d029b36ca1e9c3b2a9b78823
endef

include $(INCLUDE_DIR)/package.mk

# DDR OEI variants to build (board=<name> oei=ddr)
OEI_BOARDS:=mx95lp4x-15 mx95lp5

M33_TC_DIR=$(PKG_BUILD_DIR)/toolchain/$(M33_TC_NAME)
M33_CROSS_PATH=$(M33_TC_DIR)/bin

define Package/imx-oei
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=NXP i.MX95 DDR OEI (M33) firmware
  BUILD_TARGET:=imx
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define Build/Prepare
	$(eval $(call Download,m33-toolchain))
	$(call Build/Prepare/Default)
	$(INSTALL_DIR) $(PKG_BUILD_DIR)/toolchain
	$(TAR) -xJf $(DL_DIR)/$(M33_TC_FILE) -C $(PKG_BUILD_DIR)/toolchain
endef

define Build/Compile
	$(foreach board,$(OEI_BOARDS), \
		PATH="$(M33_CROSS_PATH):$(PATH)" \
		$(MAKE) -C $(PKG_BUILD_DIR) \
			board=$(board) oei=ddr clean; \
		PATH="$(M33_CROSS_PATH):$(PATH)" \
		$(MAKE) -C $(PKG_BUILD_DIR) \
			board=$(board) oei=ddr DEBUG=1 \
			OEI_CROSS_COMPILE=arm-none-eabi- r=B0; \
	)
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)/imx-mkimage/iMX95
	$(foreach board,$(OEI_BOARDS), \
		$(CP) $(PKG_BUILD_DIR)/build/$(board)/ddr/oei-m33-ddr.bin \
			$(STAGING_DIR_IMAGE)/imx-mkimage/iMX95/oei-m33-ddr-$(board).bin; \
	)
endef

define Package/imx-oei/install
	$(INSTALL_DIR) $(1)
endef

$(eval $(call BuildPackage,imx-oei))
