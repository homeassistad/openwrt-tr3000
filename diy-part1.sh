#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
sed -i '1i src-git kenzo https://github.com/kenzok8/openwrt-packages' feeds.conf.default
sed -i '2i src-git small https://github.com/kenzok8/small' feeds.conf.default
cp target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1.dts target/linux/mediatek/dts/mt7981b-cudy-tr3000-256mb-v1.dts
cp target/linux/mediatek/dts/mt7981b-cudy-tr3000-v1.dtsi target/linux/mediatek/dts/mt7981b-cudy-tr3000-256mb-v1.dtsi
sed -i 's|reg = <0x5c0000 0x4000000>;|reg = <0x5c0000 0xFA40000>;|' target/linux/mediatek/dts//mt7981b-cudy-tr3000-256mb-v1.dts
sed -i -e '/partition@5c0000 {/,/^[ \t]*};/ {
    s|compatible = "linux,ubi";|reg = <0x5c0000 0xFA40000>;\n\t\tcompatible = "linux,ubi";|
}' target/linux/mediatek/dts/mt7981b-cudy-tr3000-256mb-v1.dtsi
sed -i '/TARGET_DEVICES/ a \
define Device/cudy_tr3000-256mb-v1 \
  DEVICE_VENDOR := Cudy \
  DEVICE_MODEL := TR3000 \
  DEVICE_VARIANT := v1 (256mb) \
  DEVICE_DTS := mt7981b-cudy-tr3000-256mb-v1 \
  DEVICE_DTS_DIR := ../dts \
  SUPPORTED_DEVICES += R47-256MB \
  UBINIZE_OPTS := -E 5 \
  BLOCKSIZE := 128k \
  PAGESIZE := 2048 \
  IMAGE_SIZE := 250240k \
  KERNEL_IN_UBI := 1 \
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata \
  DEVICE_PACKAGES := kmod-usb3 kmod-mt7915e kmod-mt7981-firmware mt7981-wo-firmware automount \
endef \
TARGET_DEVICES += cudy_tr3000-256mb-v1
' target/linux/mediatek/image/filogic.mk
sed -i '/cudy,tr3000-v1|\\/a cudy,tr3000-256mb-v1|\\' target/linux/mediatek/filogic/base-files/etc/board.d/02_network
