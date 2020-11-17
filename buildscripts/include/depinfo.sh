#!/bin/bash -e

## Dependency versions

v_sdk=6609375_latest
v_ndk=r21d
v_sdk_build_tools=29.0.2

v_lua=5.2.4
v_libass=0.14.0
v_harfbuzz=2.7.2
v_fribidi=1.0.10
v_freetype=2-10-3
v_mbedtls=2.24.0
v_libiconv=1.15
v_zvbi=0.2.35
v_mpv=v0.32.0


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_libiconv=()
dep_zvbi=(libiconv)
dep_dav1d=()
dep_ffmpeg=(mbedtls dav1d zvbi)
dep_freetype2=()
dep_fribidi=()
dep_harfbuzz=()
dep_libass=(freetype2 fribidi harfbuzz)
dep_lua=()
dep_mpv=(ffmpeg libass lua)
dep_mpv_android=(mpv)


## Travis-related

# pinned ffmpeg commit used by travis-ci
v_travis_ffmpeg=n4.3.1

# filename used to uniquely identify a build prefix
travis_tarball="prefix-ndk-${v_ndk}-lua-${v_lua}-harfbuzz-${v_harfbuzz}-fribidi-${v_fribidi}-freetype-${v_freetype}-mbedtls-${v_mbedtls}-libiconv-${v_libiconv}-zvbi-${v_zvbi}-ffmpeg-${v_travis_ffmpeg}.tgz"
