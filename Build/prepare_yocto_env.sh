
#RUN wget https://remote.mistywest.io/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.0/oss_pkg_rzv_v3.0.0.7z
wget https://remote.mistywest.io/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.0/rzv_bsp_v3.0.0.tar.gz
wget https://remote.mistywest.io/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z13001ZJ-v1.2_EN.zip
wget https://remote.mistywest.io/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z15001ZJ-v0.58_EN.zip
wget https://remote.mistywest.io/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.0/RTK0EF0045Z0024AZJ-v3.0.0-update2.zip
wget https://remote.mistywest.io/download/mh11/rzv2l/VerifiedLinuxPackage_v3.0.0/r11an0549ej0720-rzv2l-drpai-sp.zip

cd $WORK || exit 1

unzip -o ~/RTK0EF0045Z0024AZJ-v3.0.0-update2.zip -d ~
tar zxvf ~/RTK0EF0045Z0024AZJ-v3.0.0-update2/rzv_bsp_v3.0.0.tar.gz --no-same-owner
patch -p1 < ~/RTK0EF0045Z0024AZJ-v3.0.0-update2/rzv_v300-to-v300update2.patch

unzip -o ~/RTK0EF0045Z13001ZJ-v1.2_EN.zip -d ~
tar zxvf ~/RTK0EF0045Z13001ZJ-v1.2_EN/meta-rz-features.tar.gz --no-same-owner

unzip -o ~/RTK0EF0045Z15001ZJ-v0.58_EN.zip -d ~
tar zxvf ~/RTK0EF0045Z15001ZJ-v0.58_EN/meta-rz-features.tar.gz --no-same-owner

unzip -o ~/r11an0549ej0720-rzv2l-drpai-sp.zip -d ~/r11an0549ej0720-rzv2l-drpai-sp
tar zxvf ~/r11an0549ej0720-rzv2l-drpai-sp/rzv2l_drpai-driver/meta-rz-features.tar.gz --no-same-owner
