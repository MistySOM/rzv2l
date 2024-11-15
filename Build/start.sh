#!/bin/bash
NAME="rzv_vlp_v3.0.6"
set -e
#Check hostname is a hexadecimal number of 12 
SOMHOSTNAME="MistySOM-V2L"
LOCALCONF="${WORK}/build/conf/local.conf"
hname=`hostname | grep -E -o '^[0-9a-f]{12}\b'`
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
##Apply DRPAI patch
echo "IMAGE_INSTALL_append = \" gstreamer1.0-drpai opencv\"" >> ${WORK}/meta-mistysom/recipes-core/images/mistysom-image.bbappend
#echo "applying drpai patch"
#patch -p2 < ../rzv2l-drpai-conf.patch
#echo "drpai patch applied"

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
MACHINE_FEATURES_append = " docker"
DISTRO_FEATURES_append = " virtualization"

CIP_MODE = "Bullseye"
EOT

# Set default root password
#cat <<EOT >> ${LOCALCONF}
echo "INHERIT += \"extrausers\"" >> ${LOCALCONF}
echo "EXTRA_USERS_PARAMS = \"usermod -P root root\"" >> ${LOCALCONF}
#EOT

#addition of meta-mistysom & mistylwb5p layers to bblayers.conf
sed -i 's/meta-rz-common \\/&\n'\
'  ${TOPDIR}\/..\/meta-rz-features\/meta-rz-drpai \\\n'\
'  ${TOPDIR}\/..\/meta-mistysom \\\n'\
'  ${TOPDIR}\/..\/meta-econsys \\'\
'/' ${WORK}/build/conf/bblayers.conf

# Disable recipes, tried BBMASK but was not working
rm -rf ${WORK}/meta-mistylwb5p/meta-summit-radio-pre-3.4/recipes-packages/openssl
rm -rf ${WORK}/meta-mistylwb5p/meta-summit-radio-pre-3.4/recipes-packages/summit-*

# add dunfell compatibility to layers where they're missing to avoid WARNING
echo "LAYERSERIES_COMPAT_qt5-layer = \"dunfell\"" >> ${WORK}/meta-qt5/conf/layer.conf

git config --global --add safe.directory "*"
cd ~

echo "    ------------------------------------------------
	SETUP SCRIPT BUILD ENVIRONMENT SETUP SUCCESSFUL!
	run the following commands to start the build:
	'cd ${WORK}'
	'source poky/oe-init-build-env'
	'bitbake mistysom-image'"
