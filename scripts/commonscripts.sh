#!/bin/bash
#
# Modify default IP
#sed -i 's/192.168.1.1/192.168.4.1/g' package/base-files/files/bin/config_generate
#sed -i '/^CONFIG_PACKAGE_kmod-crypto-kpp=/s/=m$/=y/' .config
#sed -i '/^CONFIG_PACKAGE_kmod-crypto-lib-curve25519=/s/=m$/=y/' .config
#sed -i '/^CONFIG_PACKAGE_kmod-crypto-lib-chacha20=/s/=m$/=y/' .config
#sed -i '/^CONFIG_PACKAGE_kmod-crypto-lib-chacha20poly1305=/s/=m$/=y/' .config
#sed -i '/^CONFIG_PACKAGE_kmod-crypto-chacha20poly1305=/s/=m$/=y/' .config
echo "CONFIG_PACKAGE_kmod-amneziawg=y" >> .config
echo "CONFIG_PACKAGE_amneziawg-go=n" >> .config
echo "CONFIG_PACKAGE_amneziawg-tools=y" >> .config
echo "CONFIG_PACKAGE_luci-proto-amneziawg=y" >> .config
