#!/bin/bash
set -e
#Check hostname is a hexadecimal number of 12 
SOMHOSTNAME="MistySOM-V2L"
LOCALCONF="${WORK}/build/conf/local.conf"
hname=`hostname | egrep -o '^[0-9a-f]{12}\b'`
echo $hname
len=${#hname}
if [ "$len" -eq 12 ];
then 
    echo "$0 is running inside container"
else
    echo "ERROR: this script needs to be run inside the Yocto build container!"
    exit
fi
git config --global user.email "yocto@mistywest.com"
git config --global user.name "Yocto"
git config --global url.https://github.com/.insteadOf git://github.com/

cd $WORK
source poky/oe-init-build-env
cd $WORK/build
cp ../meta-renesas/docs/template/conf/smarc-rzv2l/*.conf ./conf/
echo "    ------------------------------------------------"
echo "    CONFIGURATION COPIED TO conf/"
#Decompress OSS files (offline install)
if [ -z $DLOAD ];
then
	cd $WORK/build
	7z x ~/oss_pkg_rzv_v3.0.0.7z
fi
##Apply DRPAI patch
echo "IMAGE_INSTALL_append = \" gstreamer1.0-drpai ai-eva-sw\"" >> ${WORK}/meta-mistysom/recipes-core/images/mistysom-image.bbappend
#echo "applying drpai patch"
#patch -p2 < ../rzv2l-drpai-conf.patch
#echo "drpai patch applied"

## Update number of CPUs in local.conf
(NUM_CPU=$(nproc) && echo "BB_NUMBER_THREADS = \"$((NUM_CPU*2))\"" >> ${LOCALCONF}) || :

# Comment out the line that flags GPLv3 as an incompatible license
sed -i '/^INCOMPATIBLE_LICENSE = \"GPLv3 GPLv3+\"/ s/./#&/' ${LOCALCONF}
# append hostname to local.conf
echo "hostname_pn-base-files = \"${SOMHOSTNAME}\"" >> ${LOCALCONF}
#build offline tools, without network access
if [ -z $DLOAD ];
then
	sed -i 's/BB_NO_NETWORK = "0"/BB_NO_NETWORK = "1"/g' ${LOCALCONF}
fi

#Add configuration details for Laird LWB5+ module according to: https://github.com/LairdCP/meta-summit-radio/tree/lrd-10.0.0.x/meta-summit-radio-pre-3.4
cat <<EOT >> ${LOCALCONF}
PREFERRED_RPROVIDER_wpa-supplicant = "sterling-supplicant-lwb"
PREFERRED_RPROVIDER_wpa-supplicant-cli = "sterling-supplicant-lwb"
PREFERRED_RPROVIDER_wpa-supplicant-passphrase = "sterling-supplicant-lwb"
PREFERRED_RPROVIDER_wireless-regdb-static = "wireless-regdb"
EOT

#addition of meta-mistysom & mistylwb5p layers to bblayers.conf
sed -i 's/renesas \\/&\n'\
'  ${TOPDIR}\/..\/meta-mistysom \\\n'\
'  ${TOPDIR}\/..\/meta-econsys \\\n'\
'  ${TOPDIR}\/..\/meta-mistylwb5p\/meta-summit-radio-pre-3.4 \\\n'\
'  ${TOPDIR}\/..\/meta-openembedded\/meta-networking \\'\
'/' ${WORK}/build/conf/bblayers.conf

# Disable recipes, tried BBMASK but was not working
rm -rf ${WORK}/meta-mistylwb5p/meta-summit-radio-pre-3.4/recipes-packages/openssl
rm -rf ${WORK}/meta-mistylwb5p/meta-summit-radio-pre-3.4/recipes-packages/summit-*
rm -rf ${WORK}/meta-virtualization

# add dunfell compatibility to layers where they're missing to avoid WARNING
echo "LAYERSERIES_COMPAT_qt5-layer = \"dunfell\"" >> ${WORK}/meta-qt5/conf/layer.conf
echo "LAYERSERIES_COMPAT_rz-features = \"dunfell\"" >> ${WORK}/meta-rz-features/conf/layer.conf 
echo "LAYERSERIES_COMPAT_summit-radio-pre-3.4 = \"dunfell\"" >> ${WORK}/meta-mistylwb5p/meta-summit-radio-pre-3.4/conf/layer.conf

echo "    ------------------------------------------------
    SETUP SCRIPT BUILD ENVIRONMENT SETUP SUCCESSFUL!
    run the following commands to start the build:
    'cd ${WORK}'
    'source poky/oe-init-build-env'
    'bitbake mistysom-image'"
cd ~/rzv_vlp_v3.0.0

