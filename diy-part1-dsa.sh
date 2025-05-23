#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# 修改版本为编译日期，数字类型。
date_version=$(date +"%Y%m%d%H")
echo $date_version > version

# 为固件版本加上编译作者
author="Wingon"
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='%D %V ${date_version} by ${author}'/g" package/base-files/files/etc/openwrt_release
sed -i "s/OPENWRT_RELEASE.*/OPENWRT_RELEASE=\"%D %V ${date_version} by ${author}\"/g" package/base-files/files/usr/lib/os-release

# 开始复制设备信息，修改源码文件

# 复制相关文件到源码根目录
cp -rf $GITHUB_WORKSPACE/immortalwrt/* .
# 修改启动等待时间为 3 秒。
sed -i 's/default "0"/default "3"/g' config/Config-images.in

# Uboot编译处添加设备选项
sed -i '/mrkaio-m68s-rk3568 \\/a \  nsy-g16-plus-rk3568 \\\n\  nsy-g68-plus-rk3568 \\' package/boot/uboot-rockchip/Makefile
# 在"# RK3568 boards"注释行后插入两个完整的U-Boot配置块
sed -i '/# RK3568 boards/a \
\
define U-Boot\/nsy-g16-plus-rk3568\
  $(U-Boot\/rk3568\/Default)\
  NAME:=NSY G16 PLUS\
  BUILD_DEVICES:= \\\
    nsy_g16-plus\
endef\
\
define U-Boot\/nsy-g68-plus-rk3568\
  $(U-Boot\/rk3568\/Default)\
  NAME:=NSY G68 PLUS\
  BUILD_DEVICES:= \\\
    nsy_g68-plus\
endef' package/boot/uboot-rockchip/Makefile

# 适配于 24.10 位置 @@ -87,6 +87,23 @@
sed -i 's/@@ -87,6 +87,23 @@/@@ -87,6 +87,25 @@/' package/boot/uboot-rockchip/patches/900-arm-add-dts-files.patch
# 适配于 master 位置 @ -74,6 +74,20 @@
sed -i 's/@@ -74,6 +74,20 @@/@@ -74,6 +74,22 @@/' package/boot/uboot-rockchip/patches/900-arm-add-dts-files.patch
sed -i '/dtb-\$(CONFIG_ROCKCHIP_RK3568) += \\/a \\+	rk3568-nsy-g16-plus.dtb \\\n\+	rk3568-nsy-g68-plus.dtb \\' package/boot/uboot-rockchip/patches/900-arm-add-dts-files.patch

# 内核 wifi 模块添加驱动文件
sed -i '/$(PKG_BUILD_DIR)\/firmware\/mt7615_rom_patch.bin \\/a \\t\t\.\/firmware\/mt7615e_rf.bin \\' package/kernel/mt76/Makefile
# 替换原有路径并追加eeprom配置
sed -i '/mt7916_wa\.bin \\/ {
    N
    N
    s|$(PKG_BUILD_DIR)/firmware/|./firmware/|g
    a \\t\t\.\/firmware/mt7916_eeprom.bin \\
}' package/kernel/mt76/Makefile

#脚本目录添加用户分区
sed -i '/ALIGN="$6"/a USERDATASIZE="2048"' scripts/gen_image_generic.sh
# 验证修改结果
echo 用户软件分区大小：
grep -A1 'ALIGN="$6"' scripts/gen_image_generic.sh


# 添加编译设备dts 信息 
# 修改行号范围并追加设备树条目
sed -i '/^@@ -91,19 +93,25 @@/s/25/28/' target/linux/rockchip/patches-6.6/900-arm64-boot-add-dts-files.patch
sed -i '/^@@ -112,5 +120,7 @@/s/120/123/' target/linux/rockchip/patches-6.6/900-arm64-boot-add-dts-files.patch
sed -i '/rk3568-mrkaio-m68s.dtb/a\\+dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3568-nsy-g16-plus.dtb\n+dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3568-nsy-g68-plus.dtb\n+dtb-\$(CONFIG_ARCH_ROCKCHIP) += rk3568-nsy-g68-plus-dsa.dtb' target/linux/rockchip/patches-6.6/900-arm64-boot-add-dts-files.patch

# 增加 G16,G68
echo -e "\\ndefine Device/nsy_g16-plus
  DEVICE_VENDOR := NSY
  DEVICE_MODEL := G16-PLUS
  SOC := rk3568
  DEVICE_DTS := rockchip/rk3568-nsy-g16-plus
  UBOOT_DEVICE_NAME := nsy-g16-plus-rk3568
  BOOT_FLOW := pine64-img
  DEVICE_PACKAGES := kmod-mt7615-firmware wpad-openssl kmod-dsa-rtl8365mb
endef
TARGET_DEVICES += nsy_g16-plus

define Device/nsy_g68-plus
  DEVICE_VENDOR := NSY
  DEVICE_MODEL := G68-PLUS
  SOC := rk3568
  DEVICE_DTS := rockchip/rk3568-nsy-g68-plus-dsa
  UBOOT_DEVICE_NAME := nsy-g68-plus-rk3568
  BOOT_FLOW := pine64-img
  DEVICE_PACKAGES := kmod-mt7916-firmware wpad-openssl kmod-dsa-rtl8365mb
endef
TARGET_DEVICES += nsy_g68-plus" >> target/linux/rockchip/image/armv8.mk

# 网口绑定 CPU 核心
sed -i '/esac/i \
nsy,g16-plus)\
\tset_interface_core 8 "eth0"\
\tset_interface_core 4 "eth1"\
\tset_interface_core 2 "mt7615e"\
\t;;\
nsy,g68-plus)\
\tset_interface_core 8 "eth0"\
\tset_interface_core 4 "eth1"\
\tset_interface_core 2 "mt7915e"\
\t;;' target/linux/rockchip/armv8/base-files/etc/hotplug.d/net/40-net-smp-affinity

#添加交换机配置
sed -i '/rockchip_setup_interfaces()/,/case "$board" in/ {
  /case "$board" in/a \
\	nsy,g16-plus)\
\		ucidef_set_interfaces_lan_wan "eth0 lan1 lan2 lan3" "eth1 wan"\
\		;;\
\	nsy,g68-plus)\
\		uucidef_set_interfaces_lan_wan "eth0 lan1 lan2 lan3 lan4" "eth1 wan"\
\		;;
}' target/linux/rockchip/armv8/base-files/etc/board.d/02_network

# mac地址生成
sed -i '/rockchip_setup_macs()/,/case "$board" in/ {
  /case "$board" in/a \
\	nsy,g16-plus\|\\\
\	nsy,g68-plus)\
\		wan_mac=$(macaddr_generate_from_mmc_cid mmcblk0)\
\		lan_mac=$(macaddr_add "$wan_mac" 1)\
\		;;
}' target/linux/rockchip/armv8/base-files/etc/board.d/02_network

# 结束文件复制

# 拉取我的软件包仓库
# echo 'src-git xmpackages https://github.com/xiaomeng9597/openwrt-packages2.git;main' >> feeds.conf.default

# 添加科学上网插件
# echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> "feeds.conf.default"
# echo "src-git OpenClash https://github.com/vernesong/OpenClash.git;master" >> "feeds.conf.default"