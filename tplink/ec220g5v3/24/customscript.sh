#!/bin/sh
# Для python-zope-event
sed -i 's/python-setuptools\/host/python-setuptools/g' feeds/packages/lang/python/python-zope-event/Makefile
sed -i 's/python-setuptools\/host/python-setuptools/g' feeds/packages/lang/python/python-zope-interface/Makefile

# Для exim
sed -i 's/^  DEPENDS:= +USE_GLIBC:libcrypt-compat +libdb47 +libpcre2 $(ICONV_DEPENDS) +BUILD_NLS:libidn2 +BUILD_NLS:libidn$/  DEPENDS:=+libdb47 +libpcre2 $(ICONV_DEPENDS) +BUILD_NLS:libidn2 +BUILD_NLS:libidn/' feeds/packages/mail/exim/Makefile

commits="13945f4fa374419c9025eb03a5c1937b180ca9bf 0cfa434942ac4afeb7127d57a35f04999988fac9"

for commit in $commits; do
    patch_url="https://github.com/openwrt/openwrt/commit/${commit}.patch"
    curl -sL "$patch_url" -o "${commit}.patch"
    
    echo "Применяю патч: ${commit}"
    patch -p1 < "${commit}.patch" 2>/dev/null
done

for p in *.patch; do patch -p1 < "$p"; done
