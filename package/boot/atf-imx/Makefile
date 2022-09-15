# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_VERSION:=2.7
PKG_RELEASE:=$(AUTORELEASE)
PKG_HASH:=7d2020a3ba557c4a74112bfd943fc0aa

include $(INCLUDE_DIR)/trusted-firmware-a.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Trusted-Firmware-A/Default
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=cortexa53
  TFA_IMAGE:=bl31.bin
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
endef

define Trusted-Firmware-A/atf-imx8mp
  NAME:=NXP IMX8M mini evk board
  BUILD_DEVICES:=imx8mplus
  VARIANT:=imx8mp
endef

define Trusted-Firmware-A/atf-imx8mm
  NAME:=NXP IMX8M mini evk board
  BUILD_DEVICES:=imx8mmini
  VARIANT:=imx8mm
endef

TFA_TARGETS:= \
	atf-imx8mp \
	atf-imx8mm

TFA_MAKE_FLAGS += \
	PLAT=$(BUILD_VARIANT) \
	bl31

define Host/Compile
endef

define Host/Install
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/build/$(BUILD_VARIANT)/release/bl31.bin \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
endef

$(eval $(call BuildPackage/Trusted-Firmware-A))
