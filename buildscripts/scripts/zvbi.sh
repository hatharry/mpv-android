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

mkdir -p _build$ndk_suffix
cd _build$ndk_suffix

export LDFLAGS="-L$prefix_dir/lib"
export CFLAGS="-I$prefix_dir/include"
export CXX=$ndk_triple-clang++
../configure \
    --host=$ndk_triple \
    --disable-dvb --disable-bktr \
    --disable-nls --disable-proxy \
    --without-doxygen

make -j$cores
make DESTDIR="$prefix_dir" install
