#!/bin/bash

sed -i 's/https:\/\/git.openwrt.org/feeds/https:\/\/github.com\/openwrt/g' feeds.conf.default

./scripts/feeds update -a
git clone https://github.com/openwrt/packages.git officalpackages
rm -r feeds/packages/lang/golang
cp -r officalpackages/lang/golang feeds/packages/lang
rm -rf officalpackages

REPOS=(
    "https://github.com/this-username-has-been-taken/amneziawg-openwrt.git|kmod-amneziawg,amneziawg-tools,amneziawg-go,luci-proto-amneziawg"
    "https://github.com/remittor/zapret-openwrt.git|luci-app-zapret2,zapret2"
    # "https://github.com/other/repo.git|package1,package2,package3"
)
for item in "${REPOS[@]}"; do
    repo_url=$(echo $item | cut -d'|' -f1)
    packages=$(echo $item | cut -d'|' -f2)
    repo_name=$(basename $repo_url .git)
    echo "Обрабатываем $repo_name..."
    git clone --depth=1 --single-branch $repo_url
    mkdir -p package/openwrt-packages
    IFS=',' read -ra PKG_ARRAY <<< "$packages"
    for pkg in "${PKG_ARRAY[@]}"; do
        echo "  Копируем $pkg"
        cp -rf $repo_name/$pkg package/openwrt-packages/
    done
    rm -rf $repo_name
done

./scripts/feeds install -a
