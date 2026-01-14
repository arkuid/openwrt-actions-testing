#!/bin/bash

REPO_URL="https://github.com/remittor/zapret-openwrt"
REPO_NAME=`echo $REPO_URL | rev | cut -d'/' -f 1 | rev`

function merge_package(){
    pkg=`echo $1 | rev | cut -d'/' -f 1 | rev`
    [ -d package/openwrt-packages ] || mkdir -p package/openwrt-packages
    mv $REPO_NAME/$pkg package/openwrt-packages/
}

git clone --depth=1 -b master $REPO_URL

merge_package zapret2
merge_package luci-app-zapret2

rm -rf $REPO_NAME
