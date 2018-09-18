#!/bin/bash -e

. ../../include/path.sh

if [ "$1" == "build" ]; then
	true
elif [ "$1" == "clean" ]; then
	make clean
	exit 0
else
	exit 255
fi

[[ "$ndk_triple" == "i686"* ]] && export CFLAGS=-O0

$0 clean # separate building not supported, always clean

export AR=$ndk_triple-ar
make -j$cores no_test
make DESTDIR="$prefix_dir" install
