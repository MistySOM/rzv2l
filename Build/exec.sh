#!/bin/bash
#Use lower case to specify the CPU type ("v2l" or "g2l")
TYPE="v2l"
set -e
#Check hostname is a hexadecimal number of 12 
hname=`hostname | egrep -o '^[0-9a-f]{12}\b'`
OUTDIR=$WORK/out
echo $hname
len=${#hname}
FLW_FILE_URL="https://github.com/MistySOM/wiki/blob/master/files/bootloader/rzv2l/Flash_Writer_SCIF_RZV2L.mot"
BL2_FILE_URL="https://github.com/MistySOM/wiki/blob/master/files/bootloader/rzv2l/bl2_bp-MistySOMV2L.srec"
FIP_FILE_URL="https://github.com/MistySOM/wiki/blob/master/files/bootloader/rzv2l/fip-MistySOMV2L.srec"
if [[ ! "$len" -eq 12 ]];
then
    echo "ERROR: this script needs to be run inside the Yocto build container!"
    exit
fi
if [[ ! -w ${OUTDIR} ]];
then
	echo "Unable to obtain full acess  permissions to 'output' and its sub directories, edit the permissions of 'output' accordingly! exit"
	exit -1
fi
echo "WORK: $WORK"
ls -l $WORK/build


if [[ -d $WORK/build/downloads ]];
then
	echo "downloads exists"
	ls -l $WORK/build/downloads
	if [[ ! -w  $WORK/build/downloads ]];
	then
		echo "Unable to obtain write permissions to downloads and its sub directories, edit the permissions of 'cache/downloads' accordingly! exit"
		exit -1
	fi
fi
if [[ -d $WORK/build/sstate-cache ]];
then
	echo "sstate-cache exists"
	ls -l $WORK/build/sstate-cache
	if [[ ! -w $WORK/build/sstate-cache ]];
	then
		echo "Unable to obtain write permisions to sstate-cache directory, edit permissions of 'cache/sstate-cache' accordingly! exit"
		exit -1
	fi
fi

./start.sh
if [ -z $NO ];
then
	cd $WORK
	ls -l 
	source poky/oe-init-build-env
	if [ -z $SDK ]; #if $SDK is not set
	then
		time bitbake mistysom-image
	else
		time sh -c "bitbake mistysom-image && bitbake mistysom-image -c populate_sdk"
		echo "copying compiled SDK directories into 'out/'"
		cp -r $WORK/build/tmp/deploy/sdk/ ${OUTDIR}
	fi
	echo "copying compiled images into 'out/'"
	cp -r $WORK/build/tmp/deploy/images/ ${OUTDIR}
	echo "copying compiled rpms into 'out/'"
	cp -r $WORK/build/tmp/deploy/rpm/ ${OUTDIR}
 	#manually fiup bootloader files in directory
 	echo "copying bootloader files into 'out/'"
 	cd ${OUTDIR}/images/smarc-rz${TYPE}
	rm bl*
	rm fip*
	rm Flash_Writer*
	wget ${BL2_FILE_URL}
	wget ${FIP_FILE_URL}
	wget ${FLW_FILE_URL}
else
	/bin/bash
fi


