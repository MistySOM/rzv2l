#!/bin/sh

wget https://remote.mistywest.com/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.4/RTK0EF0045Z0024AZJ-v3.0.4.zip # BSP
wget https://remote.mistywest.com/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.4/RTK0EF0045Z13001ZJ-v1.1.0_EN.zip # Graphics package Evaluation version
wget https://remote.mistywest.com/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.4/RTK0EF0045Z15001ZJ-v1.1.0_EN.zip # VIDEO CODEC PACKAGE Evaluation version
wget https://remote.mistywest.com/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.4/r11an0549ej0740-rzv2l-drpai-sp.zip # DRPAI stuff for V2L

cd $WORK || exit 1

unzip -o ~/RTK0EF0045Z0024AZJ-v3.0.4.zip -d ~
tar zxvf ~/RTK0EF0045Z0024AZJ-v3.0.4/rzv_vlp_v3.0.4.tar.gz --no-same-owner

unzip -o ~/RTK0EF0045Z13001ZJ-v1.1.0_EN.zip -d ~
tar zxvf ~/RTK0EF0045Z13001ZJ-v1.1.0_EN/meta-rz-features_graphics_v1.1.0.tar.gz --no-same-owner

unzip -o ~/RTK0EF0045Z15001ZJ-v1.1.0_EN.zip -d ~
tar zxvf ~/RTK0EF0045Z15001ZJ-v1.1.0_EN/meta-rz-features_codec_v1.1.0.tar.gz --no-same-owner

unzip -o ~/r11an0549ej0740-rzv2l-drpai-sp.zip -d ~/r11an0549ej0740-rzv2l-drpai-sp
tar xvf ~/r11an0549ej0740-rzv2l-drpai-sp/rzv2l_drpai-driver/meta-rz-drpai.tar.gz -C /home/yocto/rzv_vlp_v3.0.4/ --no-same-owner
