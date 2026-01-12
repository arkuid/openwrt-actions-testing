#!/bin/bash
# Merge_package
function merge_package(){
    repo=`echo $1 | rev | cut -d'/' -f 1 | rev`
    pkg=`echo $2 | rev | cut -d'/' -f 1 | rev`
    # find package/ -follow -name $pkg -not -path "package/openwrt-packages/*" | xargs -rt rm -rf
    git clone --depth=1 --single-branch $1
    [ -d package/openwrt-packages ] || mkdir -p package/openwrt-packages
    mv $2 package/openwrt-packages/
    rm -rf $repo
}
./scripts/feeds update -a
git clone https://github.com/openwrt/packages.git officalpackages
rm -r feeds/packages/lang/golang
cp -r officalpackages/lang/golang feeds/packages/lang
rm -rf officalpackages

merge_package "-b master https://github.com/this-username-has-been-taken/amneziawg-openwrt" amneziawg-openwrt/kmod-amneziawg
merge_package "-b master https://github.com/this-username-has-been-taken/amneziawg-openwrt" amneziawg-openwrt/amneziawg-tools
merge_package "-b master https://github.com/this-username-has-been-taken/amneziawg-openwrt" amneziawg-openwrt/amneziawg-go
merge_package "-b master https://github.com/this-username-has-been-taken/amneziawg-openwrt" amneziawg-openwrt/luci-proto-amneziawg
merge_package "-b master https://github.com/remittor/zapret-openwrt/" zapret-openwrt/luci-app-zapret2
merge_package "-b master https://github.com/remittor/zapret-openwrt/" zapret-openwrt/zapret2

./scripts/feeds install -a
