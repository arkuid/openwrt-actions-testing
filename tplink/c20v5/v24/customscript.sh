#!/bin/sh
for p in *.patch; do patch -p1 -d feeds/packages < "$p"; done

cat > mktplinkfw2.patch << 'EOF'
--- a/tools/firmware-utils/patches/001-32mb-mktplinkfw2.patch
+++ b/tools/firmware-utils/patches/001-32mb-mktplinkfw2.patch
@@ -0,0 +1,15 @@
+--- firmware-utils.orig/src/mktplinkfw2.c
++++ firmware-utils/src/mktplinkfw2.c
+@@ -167,6 +167,12 @@ static struct flash_layout layouts[] = {
+ 		.kernel_la	= 0x80000000,
+ 		.kernel_ep	= 0x80000000,
+ 		.rootfs_ofs	= 0x140000,
++	}, {
++		.id		= "32MSUmtk",
++		.fw_max_len	= 0x1F70000,
++		.kernel_la	= 0x80000000,
++		.kernel_ep	= 0x80000000,
++		.rootfs_ofs	= 0x140000,
+ 	}, {
+ 		.id		= "8MLmtk",
+ 		.fw_max_len	= 0x7b0000,
+
EOF
patch -p1 < mktplinkfw2.patch

sed -i '/^define Device\/tplink_archer-c20-v5/,/^endef/ {
  s/IMAGE_SIZE := 7616k/IMAGE_SIZE := 32192k/
  s/TPLINK_FLASHLAYOUT := 8MSUmtk/TPLINK_FLASHLAYOUT := 32MSUmtk/
}' target/linux/ramips/image/mt76x8.mk

sed -i 's/reg = <0x50000 0x770000>/reg = <0x50000 0x1f70000>/' target/linux/ramips/dts/mt7628an_tplink_8m-split-uboot.dtsi

sed -i '
  s/reg = <0x7c0000 0x10000>/reg = <0x1fc0000 0x10000>/
  s/reg = <0x7d0000 0x10000>/reg = <0x1fd0000 0x10000>/
  s/reg = <0x7e0000 0x10000>/reg = <0x1fe0000 0x10000>/
  s/reg = <0x7f0000 0x10000>/reg = <0x1ff0000 0x10000>/
' target/linux/ramips/dts/mt7628an_tplink_8m-split-uboot.dtsi

# Для python-zope-event
sed -i 's/python-setuptools\/host/python-setuptools/g' feeds/packages/lang/python/python-zope-event/Makefile
sed -i 's/python-setuptools\/host/python-setuptools/g' feeds/packages/lang/python/python-zope-interface/Makefile

commits="13945f4fa374419c9025eb03a5c1937b180ca9bf 0cfa434942ac4afeb7127d57a35f04999988fac9"

for commit in $commits; do
    patch_url="https://github.com/openwrt/openwrt/pull/21239/changes/${commit}.patch"
    curl -sL "$patch_url" -o "${commit}.patch"
    
    echo "Применяю патч: ${commit}"
    patch -p1 < "${commit}.patch" 2>/dev/null
done
