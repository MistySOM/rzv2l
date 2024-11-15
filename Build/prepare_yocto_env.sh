#!/bin/sh

set -e
set -x

# download
wget -q https://remote.mistywest.com/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.6/RTK0EF0045Z0024AZJ-v3.0.6.zip # BSP
wget -q https://remote.mistywest.com/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.6/RTK0EF0045Z13001ZJ-v1.2.2_EN.zip # Graphics package Evaluation version
wget -q https://remote.mistywest.com/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.6/RTK0EF0045Z15001ZJ-v1.2.2_EN.zip # VIDEO CODEC PACKAGE Evaluation version
wget -q https://remote.mistywest.com/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.6/r11an0549ej0750-rzv2l-drpai-sp.zip # DRPAI stuff for V2L

# extract
cd $WORK || exit 1

unzip -o ~/RTK0EF0045Z0024AZJ-v3.0.6.zip -d ~
tar zxvf ~/RTK0EF0045Z0024AZJ-v3.0.6/rzv_vlp_v3.0.6.tar.gz --no-same-owner

unzip -o ~/RTK0EF0045Z13001ZJ-v1.2.2_EN.zip -d ~
tar zxvf ~/RTK0EF0045Z13001ZJ-v1.2.2_EN/meta-rz-features_graphics_v1.2.2.tar.gz --no-same-owner

unzip -o ~/RTK0EF0045Z15001ZJ-v1.2.2_EN.zip -d ~
tar zxvf ~/RTK0EF0045Z15001ZJ-v1.2.2_EN/meta-rz-features_codec_v1.2.2.tar.gz --no-same-owner

unzip -o ~/r11an0549ej0750-rzv2l-drpai-sp.zip -d ~/r11an0549ej0750-rzv2l-drpai-sp
tar xvf ~/r11an0549ej0750-rzv2l-drpai-sp/rzv2l_drpai-driver/meta-rz-drpai.tar.gz -C $WORK --no-same-owner

# clean up
echo "Cleaning Up..."
rm -rf ~/RTK0EF0045Z0024AZJ-v3.0.6.zip
rm -rf ~/RTK0EF0045Z0024AZJ-v3.0.6
rm -rf ~/RTK0EF0045Z13001ZJ-v1.2.2_EN.zip
rm -rf ~/RTK0EF0045Z13001ZJ-v1.2.2_EN
rm -rf ~/RTK0EF0045Z15001ZJ-v1.2.2_EN.zip
rm -rf ~/RTK0EF0045Z15001ZJ-v1.2.2_EN
rm -rf ~/r11an0549ej0750-rzv2l-drpai-sp.zip
rm -rf ~/r11an0549ej0750-rzv2l-drpai-sp

echo "Wrapping Layer..."
