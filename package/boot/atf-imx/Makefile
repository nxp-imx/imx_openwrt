# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=atf-imx
PKG_VERSION:=lf-5.15.5-1.0.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/imx-atf.git
PKG_SOURCE_VERSION:=lf-5.15.5-1.0.0
PKG_MIRROR_HASH:=c5de0a3152f2a0c30d25f23bb0c6cc4eab17c11f8270f5f566e998cc554180d2
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
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage-*`/iMX8M
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=imx8
  DEPENDS:=@TARGET_imx_imx8 +imx-mkimage
endef

define Package/atf-imx8mp
  $(call Package/atf-imx8m/Default)
  VARIANT:=imx8mp
endef

define Package/atf-imx8mm
  $(call Package/atf-imx8m/Default)
  VARIANT:=imx8mm
endef

define Package/atf-imx8mn
  $(call Package/atf-imx8m/Default)
  VARIANT:=imx8mn
endef

define Package/atf-imx8mq
  $(call Package/atf-imx8m/Default)
  VARIANT:=imx8mq
endef

MAKE_VARS = \
	CROSS_COMPILE="$(TARGET_CROSS)"

MAKE_FLAGS += \
	PLAT=$(BUILD_VARIANT) \
	bl31

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/build/$(BUILD_VARIANT)/release/bl31.bin \
		$$(MKIMG_DIR)
endef

$(eval $(call BuildPackage,atf-imx8mp))
$(eval $(call BuildPackage,atf-imx8mm))
$(eval $(call BuildPackage,atf-imx8mn))
$(eval $(call BuildPackage,atf-imx8mq))
