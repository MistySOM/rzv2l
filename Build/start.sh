#!/bin/bash
set -e
#Check hostname is a hexadecimal number of 12 
SOMHOSTNAME="MistySOM-V2L"
LOCALCONF="${WORK}/build/conf/local.conf"
YOCTODIR="/home/yocto/rzv_vlp_v3.0.0/" 
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
swp=`cat /proc/meminfo | grep "SwapTotal"|awk '{print $2}'`
mem=`cat /proc/meminfo | grep "MemTotal"|awk '{print $2}'`
NUM_CPU=$(((mem+swp)/1000/1000/4))
#NUM_CPU=`nproc`
##Update number of CPUs in local.conf
sed -i "1 i\PARALLEL_MAKE = \"-j ${NUM_CPU}\"\nBB_NUMBER_THREADS = \"${NUM_CPU}\"" ${LOCALCONF}
# Comment out the line that flags GPLv3 as an incompatible license
sed -i '/^INCOMPATIBLE_LICENSE = \"GPLv3 GPLv3+\"/ s/./#&/' ${LOCALCONF}
# append hostname to local.conf
echo "hostname_pn-base-files = \"${SOMHOSTNAME}\"" >> ${LOCALCONF}
#build offline tools, without network access
if [ -z $DLOAD ];
then
	sed -i 's/BB_NO_NETWORK = "0"/BB_NO_NETWORK = "1"/g' ${LOCALCONF}
fi
#addition of meta-mistysom layer to bblayers.conf
sed -i 's/renesas \\/&\n  ${TOPDIR}\/..\/meta-mistysom \\/' ${WORK}/build/conf/bblayers.conf

# add dunfell compatibility to layers wehre they're missing to avoid WARNING
echo "LAYERSERIES_COMPAT_qt5-layer = \"dunfell\"" >> ${WORK}/meta-qt5/conf/layer.conf
echo "LAYERSERIES_COMPAT_rz-features = \"dunfell\"" >> ${WORK}/meta-rz-features/conf/layer.conf 

echo "    ------------------------------------------------
    SETUP SCRIPT BUILD ENVIRONMENT SETUP SUCCESSFUL!
    run the following commands to start the build:
<<<<<<< HEAD
    'cd ${YOCTODIR}'
=======
    'cd ${WORK}'
>>>>>>> origin/develop
    'source poky/oe-init-build-env'
    'bitbake mistysom-image'"
cd ~/rzv_vlp_v3.0.0

