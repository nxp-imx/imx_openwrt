# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022-2024 NXP
#

include $(TOPDIR)/rules.mk

PKG_NAME:=imx-atf
PKG_VERSION:=lf-6.6.36-2.1.0
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/imx-atf.git
PKG_SOURCE_VERSION:=lf-6.6.36-2.1.0
PKG_MIRROR_HASH:=ba0fe2fa233c4ceb48df36ebddace182
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
  BUILD_TARGET:=imx
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

define Package/atf-imx8mn
  $(call Package/atf-imx8m/Default)
  VARIANT:=imx8mn
endef

define Package/atf-imx8mq
  $(call Package/atf-imx8m/Default)
  VARIANT:=imx8mq
endef

define Package/atf-imx93
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=NXP i.MX9 SD Boot Trusted Firmware
  BUILD_TARGET:=imx
  VARIANT:=imx93
  DEPENDS+=@TARGET_imx_cortexa55 +imx-mkimage
endef

ifeq ($(SUBTARGET),imx8)
	MKIMG_PLAT:=iMX8M
else ifeq ($(SUBTARGET),cortexa55)
	MKIMG_PLAT:=iMX93
endif

MAKE_VARS = \
	CROSS_COMPILE="$(TARGET_CROSS)"

MAKE_FLAGS += \
	PLAT=$(BUILD_VARIANT) \
	bl31

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
	$(CP) $(PKG_BUILD_DIR)/build/$(BUILD_VARIANT)/release/bl31.bin \
		$(STAGING_DIR_IMAGE)/imx-mkimage/$(MKIMG_PLAT)
endef

$(eval $(call BuildPackage,atf-imx8mp))
$(eval $(call BuildPackage,atf-imx8mm))
$(eval $(call BuildPackage,atf-imx8mn))
$(eval $(call BuildPackage,atf-imx8mq))
$(eval $(call BuildPackage,atf-imx93))
