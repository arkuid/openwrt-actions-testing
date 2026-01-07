#!/bin/sh
cat > ar9344_tplink_cpe_16mb-24.patch << 'EOF'
--- a/target/linux/ath79/dts/ar9344_tplink_cpe.dtsi
+++ b/target/linux/ath79/dts/ar9344_tplink_cpe.dtsi
@@ -69,21 +69,21 @@
 
 			partition@40000 {
 				label = "firmware";
-				reg = <0x040000 0x780000>;
+				reg = <0x040000 0xf80000>;
 				compatible = "openwrt,uimage", "denx,uimage";
 				openwrt,ih-magic = <IH_MAGIC_OKLI>;
 				openwrt,offset = <0x3000>;
 			};
 
-			partition@7c0000 {
+			partition@fc0000 {
 				label = "config";
-				reg = <0x7c0000 0x030000>;
+				reg = <0xfc0000 0x030000>;
 				read-only;
 			};
 
-			partition@7f0000 {
+			partition@ff0000 {
 				label = "art";
-				reg = <0x7f0000 0x010000>;
+				reg = <0xff0000 0x010000>;
 				read-only;
 
 				nvmem-layout {
--- a/target/linux/ath79/image/generic-tp-link.mk
+++ b/target/linux/ath79/image/generic-tp-link.mk
@@ -257,7 +257,7 @@ TARGET_DEVICES += tplink_archer-d7b-v1
 define Device/tplink_cpe210-v1
   $(Device/tplink-safeloader-okli)
   SOC := ar9344
-  IMAGE_SIZE := 7680k
+  IMAGE_SIZE := 15872k
   DEVICE_MODEL := CPE210
   DEVICE_VARIANT := v1
   DEVICE_PACKAGES := rssileds

--- a/tools/firmware-utils/patches/001-16mb-tplink-safeloader-cpe210.patch
+++ b/tools/firmware-utils/patches/001-16mb-tplink-safeloader-cpe210.patch
@@ -0,0 +1,23 @@
+--- firmware-utils.orig/src/tplink-safeloader.c
++++ firmware-utils/src/tplink-safeloader.c
+@@ -220,13 +220,13 @@ static struct device_info boards[] = {
+ 			{"default-mac", 0x30000, 0x00020},
+ 			{"product-info", 0x31100, 0x00100},
+ 			{"signature", 0x32000, 0x00400},
+-			{"firmware", 0x40000, 0x770000},
+-			{"soft-version", 0x7b0000, 0x00100},
+-			{"support-list", 0x7b1000, 0x00400},
+-			{"user-config", 0x7c0000, 0x10000},
+-			{"default-config", 0x7d0000, 0x10000},
+-			{"log", 0x7e0000, 0x10000},
+-			{"radio", 0x7f0000, 0x10000},
++			{"firmware", 0x40000, 0xf70000},
++			{"soft-version", 0xfb0000, 0x00100},
++			{"support-list", 0xfb1000, 0x00400},
++			{"user-config", 0xfc0000, 0x10000},
++			{"default-config", 0xfd0000, 0x10000},
++			{"log", 0xfe0000, 0x10000},
++			{"radio", 0xff0000, 0x10000},
+ 			{NULL, 0, 0}
+ 		},
+ 
EOF
patch -p1 < ar9344_tplink_cpe_16mb-24.patch
