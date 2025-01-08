# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024-2025 OpenWrt.org

ARCH:=aarch64
BOARDNAME:=NXP i.MX with Cortex-A53 (ARM64)
CPU_TYPE:=cortex-a53
KERNELNAME:=Image dtbs

define Target/Description
	Build firmware images for NXP i.MX (Cortex-A53) based boards.
endef
