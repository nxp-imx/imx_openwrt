# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=atf-imx
PKG_VERSION:=lf-5.15.5-1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://source.codeaurora.org/external/imx/imx-atf
PKG_SOURCE_VERSION:=lf-5.15.5-1.0.0
PKG_MIRROR_HASH:=0ed19fc34a11824cecc874ce09f4031b
PKG_FLAGS:=nonshared

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

HOST_CFLAGS += -Wall -Werror -pedantic -std=c99

define Host/Compile
endef

define Host/Install
endef

define Package/atf-imx8m/Default
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=NXP i.MX8M SD Boot Trusted Firmware
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX8M
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  DEPENDS:=@TARGET_imx_imx8
endef

define Package/atf-imx8mp
  $(call Package/atf-imx8m/Default)
  VARIANT:=imx8mp
endef

define Package/atf-imx8mm
  $(call Package/atf-imx8m/Default)
  VARIANT:=imx8mm
endef

MAKE_VARS = \
	CROSS_COMPILE="$(TARGET_CROSS)"

MAKE_FLAGS += \
	PLAT=$(BUILD_VARIANT) \
	bl31

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/build/$(BUILD_VARIANT)/release/bl31.bin \
		$(STAGING_DIR_IMAGE)/$(MKIMG_DIR)
endef

$(eval $(call BuildPackage,atf-imx8mp))
$(eval $(call BuildPackage,atf-imx8mm))
