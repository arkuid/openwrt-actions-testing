#!/bin/bash

REPO_URL="https://github.com/this-username-has-been-taken/amneziawg-openwrt"
REPO_NAME=`echo $REPO_URL | rev | cut -d'/' -f 1 | rev`

function merge_package(){
    pkg=`echo $1 | rev | cut -d'/' -f 1 | rev`
    [ -d package/openwrt-packages ] || mkdir -p package/openwrt-packages
    mv $REPO_NAME/$pkg package/openwrt-packages/
}

git clone --depth=1 --single-branch $REPO_URL

rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 24.x feeds/packages/lang/golang

merge_package kmod-amneziawg
merge_package amneziawg-tools
merge_package amneziawg-go
merge_package luci-proto-amneziawg

rm -rf $REPO_NAME

./scripts/feeds update -a
