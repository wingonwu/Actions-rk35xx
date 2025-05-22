#!/bin/bash
#===============================================
# Description: DIY script
# File name: diy-script.sh
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#===============================================

# enable rk3568 model adc keys
#cp -f $GITHUB_WORKSPACE/configfiles/adc-keys.txt adc-keys.txt
#! grep -q 'adc-keys {' package/boot/uboot-rk35xx/src/arch/arm/dts/rk3568-easepi.dts && sed -i '/\"rockchip,rk3568\";/r adc-keys.txt' package/boot/uboot-rk35xx/src/arch/arm/dts/rk3568-easepi.dts

# 修改内网IP地址为 10.0.0.1
sed -i "s/192.168.100.1/10.0.0.1/g" package/base-files/files/bin/config_generate
sed -i "s/192.168.1.1/10.0.0.1/g" package/base-files/files/bin/config_generate

# 电工大佬的rtl8367b驱动资源包，暂时使用这样替换
# wget https://github.com/xiaomeng9597/files/releases/download/files/rtl8367b.tar.gz
# tar -xvf rtl8367b.tar.gz


# openwrt主线rtl8367b驱动资源包，暂时使用这样替换
# wget https://github.com/xiaomeng9597/files/releases/download/files/rtl8367b-openwrt.tar.gz
# tar -xvf rtl8367b-openwrt.tar.gz
