#
# Copyright (C) 2013-2014,2025-2026 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=uboot-imx
PKG_VERSION:=6.12.49
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/nxp-imx/uboot-imx.git
PKG_SOURCE_VERSION:=lf-6.12.49-2.2.0
PKG_MIRROR_HASH:=f0c415ea34ef7ecf3d26d7b5bca7b43334f094edc0e3b86343a8a94ba61783e2

include $(INCLUDE_DIR)/u-boot.mk
include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=imx
endef

define U-Boot/apalis_imx6
  NAME:=Toradex Apalis
  UBOOT_IMAGE:=SPL u-boot.img u-boot-with-spl.imx
  UBOOT_MAKE_FLAGS+=SPL u-boot.img u-boot-with-spl.imx
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=toradex_apalis
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/mx6cuboxi
  NAME:=SolidRun Cubox-i boards
  UBOOT_IMAGE:=SPL u-boot-dtb.img
  UBOOT_MAKE_FLAGS+=SPL u-boot-dtb.img
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=solidrun_cubox-i
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/pico-pi-imx7d
  NAME:=TechNexion PICO-PI-IMX7D
  UBOOT_IMAGE:=SPL u-boot-dtb.img
  UBOOT_MAKE_FLAGS+=SPL u-boot-dtb.img
  BUILD_SUBTARGET:=cortexa7
  BUILD_DEVICES:=technexion_imx7d-pico-pi
  UBOOT_MAKE_FLAGS += u-boot.imx
endef

define U-Boot/wandboard
  NAME:=Wandboard Dual Lite/Quad/Solo
  BUILD_SUBTARGET:=cortexa9
  BUILD_DEVICES:=wandboard_dual
  UBOOT_MAKE_FLAGS += u-boot.imx
  UBOOT_IMAGE:=u-boot.imx
endef

define U-Boot/imx6ull
  NAME:=imx6ultra lite board
  BUILD_SUBTARGET:=cortexa7
  BUILD_DEVICES:=imx6ull
  UBOOT_CONFIG:=mx6ull_14x14_evk
  ENV_SIZE:=0x2000
  ENV_NAME:=imx6ull-sdboot
  DTB_NAME:=imx6ull-14x14-evk
  UBOOT_IMAGE:=u-boot-dtb.imx
endef

define U-Boot/imx8mp
  NAME:=imx8mplus lpddr4 board
  BUILD_TARGET:=imx
  UBOOT_CONFIG:=imx8mp_evk
  ENV_NAME:=imx8mp-sdboot
  DTB_NAME:=imx8mp-evk.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX8M
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx8mpfrdm
  NAME:=imx8mplus frdm board
  BUILD_TARGET:=imx
  UBOOT_CONFIG:=imx8mp_frdm
  ENV_NAME:=imx8mpfrdm-sdboot
  DTB_NAME:=imx8mp-frdm.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX8M
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx8mm
  NAME:=imx8mmini lpddr4 board
  BUILD_TARGET:=imx
  BUILD_SUBTARGET:=cortexa53
  UBOOT_CONFIG:=imx8mm_evk
  ENV_NAME:=imx8mm-sdboot
  DTB_NAME:=imx8mm-evk.dtb
  DEPENDS:=+imx-mkimage
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX8M
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx8mn
  NAME:=imx8mnano lpddr4 board
  BUILD_TARGET:=imx
  UBOOT_CONFIG:=imx8mn_evk
  ENV_NAME:=imx8mn-sdboot
  DTB_NAME:=imx8mn-evk.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX8M
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx8mq
  NAME:=imx8mquad lpddr4 board
  BUILD_TARGET:=imx
  UBOOT_CONFIG:=imx8mq_evk
  ENV_NAME:=imx8mq-sdboot
  DTB_NAME:=imx8mq-evk.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX8M
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx91evk
  BUILD_DEVICES:=imx91
  NAME:=imx91evk board
  UBOOT_CONFIG:=imx91_11x11_evk
  ENV_NAME:=imx91evk-sdboot
  DTB_NAME:=imx91-11x11-evk.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX91
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx91frdm
  BUILD_DEVICES:=imx91
  NAME:=imx91frdm board
  UBOOT_CONFIG:=imx91_11x11_frdm
  ENV_NAME:=imx91frdm-sdboot
  DTB_NAME:=imx91-11x11-frdm.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX91
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx91frdm-imx91s
  BUILD_DEVICES:=imx91
  NAME:=imx91s frdm board
  UBOOT_CONFIG:=imx91_11x11_frdm_imx91s
  ENV_NAME:=imx91frdm-imx91s-sdboot
  DTB_NAME:=imx91-11x11-frdm-imx91s.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX91
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx91qsb
  BUILD_DEVICES:=imx91
  NAME:=imx91qsb board
  UBOOT_CONFIG:=imx91_9x9_qsb
  ENV_NAME:=imx91qsb-sdboot
  DTB_NAME:=imx91-9x9-qsb.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX91
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx93evk
  BUILD_DEVICES:=imx93
  NAME:=imx93evk board
  UBOOT_CONFIG:=imx93_11x11_evk
  ENV_NAME:=imx93evk-sdboot
  DTB_NAME:=imx93-11x11-evk.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX93
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx93frdm
  BUILD_DEVICES:=imx93
  NAME:=imx93frdm board
  UBOOT_CONFIG:=imx93_11x11_frdm
  ENV_NAME:=imx93frdm-sdboot
  DTB_NAME:=imx93-11x11-frdm.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX93
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx93qsb
  BUILD_DEVICES:=imx93
  NAME:=imx93qsb board
  UBOOT_CONFIG:=imx93_9x9_qsb
  ENV_NAME:=imx93qsb-sdboot
  DTB_NAME:=imx93-9x9-qsb.dtb
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX93
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage
endef

define U-Boot/imx95_15x15_evk
  BUILD_DEVICES:=imx95
  NAME:=imx95 15x15 evk board
  UBOOT_CONFIG:=imx95_15x15_evk
  ENV_NAME:=imx95_15x15_evk-sdboot
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX95
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage +imx-sm +imx-oei
endef

define U-Boot/imx95_19x19_evk
  BUILD_DEVICES:=imx95
  NAME:=imx95 19x19 evk board
  UBOOT_CONFIG:=imx95_19x19_evk
  ENV_NAME:=imx95_19x19_evk-sdboot
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX95
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage +imx-sm +imx-oei
endef

define U-Boot/imx95frdm
  BUILD_DEVICES:=imx95
  NAME:=imx95 frdm board
  UBOOT_CONFIG:=imx95_15x15_frdm
  ENV_NAME:=imx95frdm-sdboot
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX95
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage +imx-sm +imx-oei
endef

define U-Boot/imx95frdmpro
  BUILD_DEVICES:=imx95
  NAME:=imx95 frdm-pro board
  UBOOT_CONFIG:=imx95_19x19_frdm_pro
  ENV_NAME:=imx95frdmpro-sdboot
  ENV_SIZE:=0x4000
  IMG_DIR:=iMX95
  DEPENDS:=@TARGET_imx_cortexa53 +imx-mkimage +imx-sm +imx-oei
endef

UBOOT_TARGETS := \
	apalis_imx6 \
	mx6cuboxi \
	pico-pi-imx7d \
	wandboard \
	imx6ull \
	imx8mp \
	imx8mpfrdm \
	imx8mm \
	imx8mn \
	imx8mq \
	imx91evk \
	imx91frdm \
	imx91frdm-imx91s \
	imx91qsb \
	imx93evk \
	imx93frdm \
	imx93qsb \
	imx95_15x15_evk \
	imx95_19x19_evk \
	imx95frdm \
	imx95frdmpro

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)
ifeq ($(SUBTARGET),cortexa53)
	$(CP) $(PKG_BUILD_DIR)/u-boot-nodtb.bin \
		$(PKG_BUILD_DIR)/u-boot.bin \
		$(PKG_BUILD_DIR)/spl/u-boot-spl.bin \
		$(STAGING_DIR_IMAGE)/imx-mkimage/$(IMG_DIR)
	# Boards with CONFIG_OF_UPSTREAM (e.g. the EVKs) build the device tree
	# under dts/upstream/src/arm64/freescale, while NXP-specific boards
	# (e.g. the FRDM boards) build it under arch/arm/dts. Copy from
	# whichever location the DTB was produced in.
	# i.MX95 boards embed the DTB in the boot container (binman) and set an
	# empty DTB_NAME, so the copy is skipped for them.
ifneq ($(DTB_NAME),)
	if [ -f $(PKG_BUILD_DIR)/dts/upstream/src/arm64/freescale/$(DTB_NAME) ]; then \
		$(CP) $(PKG_BUILD_DIR)/dts/upstream/src/arm64/freescale/$(DTB_NAME) \
			$(STAGING_DIR_IMAGE)/imx-mkimage/$(IMG_DIR); \
	else \
		$(CP) $(PKG_BUILD_DIR)/arch/arm/dts/$(DTB_NAME) \
			$(STAGING_DIR_IMAGE)/imx-mkimage/$(IMG_DIR); \
	fi
endif
	$(CP) $(PKG_BUILD_DIR)/tools/mkimage \
		$(STAGING_DIR_IMAGE)/imx-mkimage/$(IMG_DIR)/mkimage_uboot
endif

ifneq ($(UBOOT_IMAGE),)
	$(foreach img,$(UBOOT_IMAGE), \
		$(CP) $(PKG_BUILD_DIR)/$(img) $(STAGING_DIR_IMAGE)/$(BUILD_VARIANT)-$(img); \
	)
endif

ifneq ($(ENV_NAME),)
	$(PKG_BUILD_DIR)/tools/mkenvimage -s $(ENV_SIZE) \
		-o $(STAGING_DIR_IMAGE)/$(ENV_NAME)-uboot-env.bin \
		files/$(ENV_NAME)-uEnv.txt
endif
endef

define Package/u-boot/install/default
endef

$(eval $(call BuildPackage/U-Boot))
