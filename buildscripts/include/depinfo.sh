#!/bin/bash -e

## Dependency versions

v_sdk=3859397
v_ndk=r19c
v_sdk_build_tools=28.0.3

v_lua=5.2.4
v_libass=0.14.0
v_fribidi=1.0.5
v_freetype=2-10-0
v_mbedtls=2.16.1
v_libiconv=1.15
v_zvbi=0.2.35
v_mpv=master


## Dependency tree
# I would've used a dict but putting arrays in a dict is not a thing

dep_mbedtls=()
dep_libiconv=()
dep_zvbi=(libiconv)
dep_ffmpeg=(mbedtls zvbi)
dep_freetype2=()
dep_fribidi=()
dep_libass=(freetype2 fribidi)
dep_lua=()
dep_mpv=(ffmpeg libass lua)
dep_mpv_android=(mpv)


## Travis-related

# pinned ffmpeg commit used by travis-ci
v_travis_ffmpeg=n4.1.4

# filename used to uniquely identify a build prefix
travis_tarball="prefix-ndk-${v_ndk}-lua-${v_lua}-libass-${v_libass}-fribidi-${v_fribidi}-freetype-${v_freetype}-mbedtls-${v_mbedtls}-libiconv-${v_libiconv}-zvbi-${v_zvbi}-ffmpeg-${v_travis_ffmpeg}.tgz"
