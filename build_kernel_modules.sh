#!/bin/bash
set -xe

function build {
    echo Building $1 $2 $3
    KERNEL=$1
    UNAME_R=$2
    DOCKERFILE=$3
    UNAME_R=$UNAME_R
    FILE=zfs-${UNAME_R}.tar.gz
    RELEASEDIR=/pool/releases/zfs
    if [ -e $RELEASEDIR/$FILE ]; then
        echo "Skipping $FILE, already exists"
    else
        echo docker build --build-arg KERN_CONF_SUFFIX=$DOCKERFILE --build-arg KERNEL_VERSION=$KERNEL -t lmarsden/build-zfs-$DOCKERFILE:${UNAME_R} -f Dockerfile.$DOCKERFILE .
        echo docker run -e UNAME_R=$UNAME_R -v ${PWD}/rootfs:/rootfs lmarsden/build-zfs-$DOCKERFILE:${UNAME_R} /build_zfs.sh
        echo cp rootfs/$FILE $RELEASEDIR/
    fi
}

# docker4mac

versions=$(cd d4m-poller && ./check.sh)
echo Building docker4mac versions:
echo $versions
for version in $versions; do
    build ${version} ${version}-moby docker4mac
done

# boot2docker
# look up docker version -> kernel mapping here:
# https://github.com/boot2docker/boot2docker/releases

versions=$(curl -sSL https://github.com/boot2docker/boot2docker/releases|grep Linux |awk '/pub/ {print $3}' |awk -F 'v' '{print $3}' |awk -F '<' '{print $1}')
echo Building boot2docker versions:
echo $versions

for version in $versions; do
    build $version $version-boot2docker boot2docker
done

# travis trusty XXX TODO create Dockerfile.ubuntu-trusty and
# kernel_config.ububtu-trusty
#build 3.19 3.19.0-30-generic ubuntu-trusty
