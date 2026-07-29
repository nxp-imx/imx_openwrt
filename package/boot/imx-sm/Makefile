# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2026 NXP

include $(TOPDIR)/rules.mk

PKG_NAME:=imx-sm
PKG_VERSION:=6.12.49
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/imx-sm.git
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

# SM board config: mx95evk covers the i.MX95 15x15/19x19 EVK and FRDM boards.
SM_CONFIG:=mx95evk
M33_TC_DIR=$(PKG_BUILD_DIR)/toolchain/$(M33_TC_NAME)
M33_CROSS_PATH=$(M33_TC_DIR)/bin

define Package/imx-sm
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=NXP i.MX95 System Manager (M33) firmware
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
	+PATH="$(M33_CROSS_PATH):$(PATH)" \
	$(MAKE) -C $(PKG_BUILD_DIR) \
		SM_CROSS_COMPILE=arm-none-eabi- \
		config=$(SM_CONFIG) clean
	+PATH="$(M33_CROSS_PATH):$(PATH)" \
	$(MAKE) -C $(PKG_BUILD_DIR) \
		SM_CROSS_COMPILE=arm-none-eabi- \
		config=$(SM_CONFIG) M=2
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)/imx-mkimage/iMX95
	$(CP) $(PKG_BUILD_DIR)/build/$(SM_CONFIG)/m33_image.bin \
		$(STAGING_DIR_IMAGE)/imx-mkimage/iMX95/
endef

define Package/imx-sm/install
	$(INSTALL_DIR) $(1)
endef

$(eval $(call BuildPackage,imx-sm))
