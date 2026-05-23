#!/bin/bash

sed -i \
  -e 's|https://git.openwrt.org/feed/|https://github.com/openwrt/|g' \
  -e 's|https://git.openwrt.org/project/|https://github.com/openwrt/|g' \
  feeds.conf.default

./scripts/feeds update -a
rm -rf feeds/packages/lang/golang
git clone https://github.com/sbwml/packages_lang_golang -b 26.x feeds/packages/lang/golang

REPOS=(
    "https://github.com/this-username-has-been-taken/amneziawg-openwrt.git|master|kmod-amneziawg,amneziawg-tools,amneziawg-go,luci-proto-amneziawg"
    #"https://github.com/remittor/zapret-openwrt.git|master|luci-app-zapret2,zapret2"
    # "https://github.com/other/repo.git|branch_name|package1,package2,package3"
)

for item in "${REPOS[@]}"; do
    repo_url=$(echo $item | cut -d'|' -f1)
    branch=$(echo $item | cut -d'|' -f2)
    packages=$(echo $item | cut -d'|' -f3)
    repo_name=$(basename $repo_url .git)
    echo "Обрабатываем $repo_name (ветка: $branch)..."
    git clone --depth=1 --single-branch --branch "$branch" "$repo_url"
    mkdir -p package/openwrt-packages
    IFS=',' read -ra PKG_ARRAY <<< "$packages"
    for pkg in "${PKG_ARRAY[@]}"; do
        echo "  Копируем $pkg"
        cp -rf "$repo_name/$pkg" package/openwrt-packages/
    done
    rm -rf "$repo_name"
done

./scripts/feeds install -a
