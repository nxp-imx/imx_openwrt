# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2025-2026 NXP
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=mwifiex
PKG_VERSION:=6.12.49
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/mwifiex.git
PKG_SOURCE_VERSION:=lf-6.12.49-2.2.0
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_MIRROR_HASH:=c8a255618db6827e1c729321a279e8283da31501a14ca412664acfd0968bc09f
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

define KernelPackage/mwifiex-default
  SUBMENU:=Wireless Drivers
  SECTION:=kernel
  DEPENDS:= +kmod-moal +kmod-mlan +kmod-imx-firmware
endef

define KernelPackage/mwifiex-firmware-default
  SUBMENU:=Wireless Drivers
  SECTION:=kernel
endef

define KernelPackage/mlan
  SUBMENU:=Wireless Drivers
  SECTION:=kernel
  TITLE:=NXP WIFI MLAN DRIVER
  HIDDEN:=1
  FILES:= $(PKG_BUILD_DIR)/mlan.ko
endef

define KernelPackage/moal
  SUBMENU:=Wireless Drivers
  SECTION:=kernel
  TITLE:=NXP WIFI MOAL DRIVER
  HIDDEN:=1
  DEPENDS:=+kmod-mlan
  FILES:= $(PKG_BUILD_DIR)/moal.ko
endef

define KernelPackage/mwifiex-8801-sdio-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP WIFI 8801 SDIO Driver firmware
endef

define KernelPackage/mwifiex-8801-sdio-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_8801_SD/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-8801-sdio
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP WIFI 8801 SDIO Driver
  DEPENDS+=+kmod-mwifiex-8801-sdio-firmware
endef

define KernelPackage/mwifiex-8987-sdio-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP WIFI 8987 SDIO Driver firmware
endef

define KernelPackage/mwifiex-8987-sdio-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_8987_SD/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-8987-sdio
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP WIFI 8987 SDIO Driver
  DEPENDS+= +kmod-mwifiex-8987-sdio-firmware
endef

define KernelPackage/mwifiex-8997-pcie-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP WIFI 8997 PCIe Driver firmware
endef

define KernelPackage/mwifiex-8997-pcie-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_8997_PCIE/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-8997-pcie
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP WIFI 8997 PCIe Driver
  DEPENDS+= +kmod-mwifiex-8997-pcie-firmware
endef

define KernelPackage/mwifiex-8997-sdio-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP WIFI 8997 SDIO Driver firmware
endef

define KernelPackage/mwifiex-8997-sdio-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_8997_SD/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-8997-sdio
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP WIFI 8997 SDIO Driver
  CONFLICTS:=kmod-mwifiex-8997-pcie
  DEPENDS+= +kmod-mwifiex-8997-sdio-firmware
endef

define KernelPackage/mwifiex-9098-pcie-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP WIFI 9098 PCIe Driver firmware
endef

define KernelPackage/mwifiex-9098-pcie-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_9098_PCIE/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-9098-pcie
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP WIFI 9098 PCIe Driver
  DEPENDS+= +kmod-mwifiex-9098-pcie-firmware
endef

define KernelPackage/mwifiex-9098-sdio-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP WIFI 9098 SDIO Driver firmware
endef

define KernelPackage/mwifiex-9098-sdio-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_9098_SD/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-9098-sdio
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP WIFI 9098 SDIO Driver
  CONFLICTS:=kmod-mwifiex-9098-pcie
  DEPENDS+= +kmod-mwifiex-9098-sdio-firmware
endef

define KernelPackage/mwifiex-iw416-sdio-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP IW416 SDIO Driver firmware
endef

define KernelPackage/mwifiex-iw416-sdio-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_IW416_SD/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-iw416-sdio
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP IW416 SDIO Driver
  DEPENDS+= +kmod-mwifiex-iw416-sdio-firmware
endef

define KernelPackage/mwifiex-iw610-sdio
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP IW610 SDIO Driver
  DEPENDS+= +kmod-mwifiex-iw610-sdio-firmware
endef

define KernelPackage/mwifiex-iw610-sdio-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP iw610 SDIO Driver firmware
endef

define KernelPackage/mwifiex-iw610-sdio-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_IW610_SD/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-iw612-sdio
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP IW612 SDIO Driver
  DEPENDS+= +kmod-mwifiex-iw612-sdio-firmware
endef

define KernelPackage/mwifiex-iw612-sdio-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP iw612 SDIO Driver firmware
endef

define KernelPackage/mwifiex-iw612-sdio-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/FwImage_IW612_SD/* \
		$(1)/lib/firmware/nxp
endef

define KernelPackage/mwifiex-iw612-sdio
  $(KernelPackage/mwifiex-default)
  TITLE:=NXP IW612 SDIO Driver
  DEPENDS+= +kmod-mwifiex-iw612-sdio-firmware
endef

include $(INCLUDE_DIR)/kernel-defaults.mk

MWIFIEX_FM_NAME:=imx-firmware
MWIFIEX_FM_VER:=lf-6.12.49-2.2.0
MWIFIEX_FM_SOURCE:=$(MWIFIEX_FM_NAME)-$(MWIFIEX_FM_VER).tar.bz2
define Download/imx-firmware
  FILE:=$(MWIFIEX_FM_SOURCE)
  PROTO:=git
  URL:=https://github.com/nxp-imx/imx-firmware.git
  VERSION:=lf-6.12.49-2.2.0
  SUBDIR:=mwifiex-firmware
  MIRROR_HASH:=478c9811fea3104eb2fecb6ae07526c42b4c6e9a192e19266d1ecf2ce73bd3d6
endef

define KernelPackage/imx-firmware
  $(KernelPackage/mwifiex-firmware-default)
  TITLE:=NXP Driver firmware including config and SCR file
  HIDDEN:=1
endef

define KernelPackage/imx-firmware/install
	$(INSTALL_DIR) $(1)/lib/firmware/nxp/
	$(CP) \
		$(BUILD_DIR)/mwifiex-firmware/wifi_mod_para.conf \
		$(BUILD_DIR)/mwifiex-firmware/SCR-imx-firmware.txt \
		$(1)/lib/firmware/nxp
endef

define Build/Prepare
	$(eval $(call Download,imx-firmware))
	$(call Build/Prepare/Default,)

	$(TAR) -C $(BUILD_DIR) -xf $(DL_DIR)/$(MWIFIEX_FM_SOURCE)
endef

define Build/Compile
	+$(KERNEL_MAKE) M="$(PKG_BUILD_DIR)" modules
endef

$(eval $(call KernelPackage,moal))
$(eval $(call KernelPackage,mlan))
$(eval $(call KernelPackage,imx-firmware))
$(eval $(call KernelPackage,mwifiex-8801-sdio-firmware))
$(eval $(call KernelPackage,mwifiex-8801-sdio))
$(eval $(call KernelPackage,mwifiex-8987-sdio-firmware))
$(eval $(call KernelPackage,mwifiex-8987-sdio))
$(eval $(call KernelPackage,mwifiex-8997-pcie-firmware))
$(eval $(call KernelPackage,mwifiex-8997-pcie))
$(eval $(call KernelPackage,mwifiex-8997-sdio-firmware))
$(eval $(call KernelPackage,mwifiex-8997-sdio))
$(eval $(call KernelPackage,mwifiex-9098-pcie-firmware))
$(eval $(call KernelPackage,mwifiex-9098-pcie))
$(eval $(call KernelPackage,mwifiex-9098-sdio-firmware))
$(eval $(call KernelPackage,mwifiex-9098-sdio))
$(eval $(call KernelPackage,mwifiex-iw416-sdio-firmware))
$(eval $(call KernelPackage,mwifiex-iw416-sdio))
$(eval $(call KernelPackage,mwifiex-iw610-sdio-firmware))
$(eval $(call KernelPackage,mwifiex-iw610-sdio))
$(eval $(call KernelPackage,mwifiex-iw612-sdio-firmware))
$(eval $(call KernelPackage,mwifiex-iw612-sdio))
