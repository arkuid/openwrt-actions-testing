#!/bin/sh

cat > tp20v4-org-16mb-usb.patch << 'EOF'
--- a/tools/firmware-utils/patches/001-16mb-mktplinkfw2.patch
+++ b/tools/firmware-utils/patches/001-16mb-mktplinkfw2.patch
@@ -0,0 +1,15 @@
+--- firmware-utils.orig/src/mktplinkfw2.c
++++ firmware-utils/src/mktplinkfw2.c
+@@ -149,6 +149,12 @@ static struct flash_layout layouts[] = {
+ 		.kernel_la	= 0x80000000,
+ 		.kernel_ep	= 0x80000000,
+ 		.rootfs_ofs	= 0x140000,
++	}, {
++		.id		= "16Mmtk",
++		.fw_max_len	= 0xfa0000,
++		.kernel_la	= 0x80000000,
++		.kernel_ep	= 0x80000000,
++		.rootfs_ofs	= 0x140000,
+ 	}, {
+ 		.id		= "8MSUmtk", /* Split U-Boot OS */
+ 		.fw_max_len	= 0x770000,

EOF
patch -p1 < tp20v4-org-16mb-usb.patch

sed -i 's/IMAGE_SIZE := 7808k/IMAGE_SIZE := 16000k/; s/TPLINK_FLASHLAYOUT := 8Mmtk/TPLINK_FLASHLAYOUT := 16Mmtk/; s/DEVICE_PACKAGES := kmod-mt76x0e/DEVICE_PACKAGES := kmod-mt76x0e kmod-usb2 kmod-usb-ohci/' target/linux/ramips/image/mt76x8.mk
sed -i '/&ehci\|&ohci/{n;s/status = "disabled"/status = "okay"/}' target/linux/ramips/dts/mt7628an_tplink_archer-c20-v4.dts
sed -i 's/7a0000/fa0000/; s/7c/fc/g; s/7d/fd/g' target/linux/ramips/dts/mt7628an_tplink_8m.dtsi


for p in *.patch; do patch -p1 -d feeds/packages < "$p"; done



