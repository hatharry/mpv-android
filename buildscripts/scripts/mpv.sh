#!/bin/bash -e

. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	rm -rf _build$ndk_suffix
	exit 0
else
	exit 255
fi

[ -f waf ] || ./bootstrap.py

extrald=
extra=
[[ "$ndk_triple" == "aarch64"* ]] && extrald="-fuse-ld=gold"
[[ "$ndk_triple" == "i686"* ]] && extra="--disable-asm"

LDFLAGS="$extrald" \
./waf configure \
	--disable-iconv --lua=52 \
	--enable-libmpv-shared \
	--disable-manpage-build \
	--enable-lgpl \
	-o "`pwd`/_build$ndk_suffix" \
	$extra

./waf build -j$cores
./waf install --destdir="$prefix_dir"
