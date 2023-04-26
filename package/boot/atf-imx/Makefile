# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright 2022 NXP
#

include $(TOPDIR)/rules.mk


PKG_NAME:=atf-imx93
PKG_VERSION:=v5.15
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/imx-atf.git
PKG_SOURCE_VERSION:=imx_5.15.32_imx93_er1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk

define Package/atf-imx8m/Default
  SECTION:=boot
  CATEGORY:=Boot Loaders
  TITLE:=NXP i.MX8M SD Boot Trusted Firmware
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX9
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=cortexa53
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
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
  $(call Package/atf-imx8m/Default)
  MKIMG_DIR:=`find $(STAGING_DIR_IMAGE) -name imx-mkimage*  | xargs basename`/iMX9
  VARIANT:=imx93
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
$(eval $(call BuildPackage,atf-imx8mn))
$(eval $(call BuildPackage,atf-imx8mq))
$(eval $(call BuildPackage,atf-imx93))
