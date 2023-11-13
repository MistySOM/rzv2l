#!/bin/bash
#Use lower case to specify the CPU type ("v2l" or "g2l")
TYPE="v2l"
set -e
#Check hostname is a hexadecimal number of 12 
hname=`hostname | egrep -o '^[0-9a-f]{12}\b'`
OUTDIR=$WORK/out
echo $hname
len=${#hname}
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
if [[ ! -w $WORK/build/sstate-cache || ! -w $WORK/build/downloads ]];
then
	echo "Unable to obtain write permissions to 'cache' and its sub directories, edit the permissions of 'cache' accordingly! exit"
	exit -1
fi


./start.sh
if [ -z $NO ];
then
	cd $WORK
	source poky/oe-init-build-env
	if [ -z $SDK ]; #if $SDK is not set
	then
		time bitbake mistysom-image
		echo "copying compiled images into 'out/'"
		cp -r $WORK/build/tmp/deploy/images/ ${OUTDIR}
	else
		time sh -c "bitbake mistysom-image && bitbake mistysom-image -c populate_sdk"
		echo "copying compiled images & SDK directories into 'out/'"
		cp -r $WORK/build/tmp/deploy/sdk/ ${OUTDIR}
		cp -r $WORK/build/tmp/deploy/images/ ${OUTDIR}
	fi
 	#manually fiup bootloader files in directory
 	cd ${OUTDIR}/images/smarc-${board}
	rm bl*
	m fip*
	rm Flash_Writer*
	wget https://github.com/MistySOM/wiki/blob/master/files/bootloader/rzv2l/Flash_Writer_SCIF_rz${TYPE}.mot
	wget https://github.com/MistySOM/wiki/blob/master/files/bootloader/rzv2l/bl2_bp-MistySOM${TYPE^^}.srec
	wget https://github.com/MistySOM/wiki/blob/master/files/bootloader/rzv2l/fip-MistySOM${TYPE^^}.srec
else
	/bin/bash
fi


