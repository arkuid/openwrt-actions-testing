#!/bin/bash

REPO_URL="https://github.com/this-username-has-been-taken/amneziawg-openwrt"
REPO_NAME=`echo $REPO_URL | rev | cut -d'/' -f 1 | rev`

function merge_package(){
    pkg=`echo $1 | rev | cut -d'/' -f 1 | rev`
    [ -d package/openwrt-packages ] || mkdir -p package/openwrt-packages
    mv $REPO_NAME/$pkg package/openwrt-packages/
}

./scripts/feeds update -a

git clone --depth=1 --single-branch $REPO_URL

git clone https://github.com/openwrt/packages.git officalpackages
rm -r feeds/packages/lang/golang
cp -r officalpackages/lang/golang feeds/packages/lang
rm -rf officalpackages

merge_package kmod-amneziawg
merge_package amneziawg-tools
merge_package amneziawg-go
merge_package luci-proto-amneziawg

rm -rf $REPO_NAME
