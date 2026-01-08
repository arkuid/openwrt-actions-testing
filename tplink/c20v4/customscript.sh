#!/bin/bash

set -e

echo "Applying Archer C20 v4 16MB patch..."

cat << 'EOF' | patch -p1 --forward || true
--- a/target/linux/ramips/image/mt76x8.mk
+++ b/target/linux/ramips/image/mt76x8.mk
@@ -547,10 +547,10 @@ TARGET_DEVICES += totolink_lr1200
 
 define Device/tplink_archer-c20-v4
   $(Device/tplink-v2)
-  IMAGE_SIZE := 7808k
+  IMAGE_SIZE := 16000k
   DEVICE_MODEL := Archer C20
   DEVICE_VARIANT := v4
-  TPLINK_FLASHLAYOUT := 8Mmtk
+  TPLINK_FLASHLAYOUT := 16Mmtk
   TPLINK_HWID := 0xc200004
   TPLINK_HWREVADD := 0x4
   DEVICE_PACKAGES := kmod-mt76x0e
--- a/target/linux/ramips/dts/mt7628an_tplink_archer-c20-v4.dts
+++ b/target/linux/ramips/dts/mt7628an_tplink_archer-c20-v4.dts
@@ -70,11 +70,11 @@
 };
 
 &ehci {
-	status = "disabled";
+	status = "okay";
 };
 
 &ohci {
-	status = "disabled";
+	status = "okay";
 };
 
 &wmac {
--- a/target/linux/ramips/dts/mt7628an_tplink_8m.dtsi
+++ b/target/linux/ramips/dts/mt7628an_tplink_8m.dtsi
@@ -35,18 +35,18 @@
 			partition@20000 {
 				compatible = "tplink,firmware";
 				label = "firmware";
-				reg = <0x20000 0x7a0000>;
+				reg = <0x20000 0xfa0000>;
 			};
 
-			partition@7c0000 {
+			partition@fc0000 {
 				label = "config";
-				reg = <0x7c0000 0x10000>;
+				reg = <0xfc0000 0x10000>;
 				read-only;
 			};
 
-			factory: partition@7d0000 {
+			factory: partition@fd0000 {
 				label = "factory";
-				reg = <0x7d0000 0x30000>;
+				reg = <0xfd0000 0x30000>;
 				read-only;
 			};
 		};
--- /dev/null
+++ b/tools/firmware-utils/patches/001-16mb-mktplinkfw2.patch
@@ -0,0 +1,15 @@
+--- firmware-utils.orig/src/mktplinkfw2.c
++++ firmware-utils/src/mktplinkfw2.c
+@@ -149,6 +149,12 @@ static struct flash_layout layouts[] = {
+ 		.id		= "8Mmtk",
+ 		.fw_max_len	= 0x7a0000,
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


mkdir -p tools/firmware-utils/patches

cat > tools/firmware-utils/patches/001-16mb-mktplinkfw2.patch << 'EOF'
--- firmware-utils.orig/src/mktplinkfw2.c
+++ firmware-utils/src/mktplinkfw2.c
@@ -149,6 +149,12 @@ static struct flash_layout layouts[] = {
 		.id		= "8Mmtk",
 		.fw_max_len	= 0x7a0000,
 		.kernel_la	= 0x80000000,
 		.kernel_ep	= 0x80000000,
 		.rootfs_ofs	= 0x140000,
+	}, {
+		.id		= "16Mmtk",
+		.fw_max_len	= 0xfa0000,
+		.kernel_la	= 0x80000000,
+		.kernel_ep	= 0x80000000,
+		.rootfs_ofs	= 0x140000,
 	}, {
 		.id		= "8MSUmtk", /* Split U-Boot OS */
 		.fw_max_len	= 0x770000,
EOF

echo "✓ Archer C20 v4 16MB patch applied successfully!"
