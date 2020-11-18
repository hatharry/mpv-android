#!/bin/bash -e

cd "$( dirname "${BASH_SOURCE[0]}" )"

. ./include/depinfo.sh

build_prefix() {
	echo "==> Building the prefix ($travis_tarball)..."

	echo "==> Fetching deps"
	TRAVIS=1 ./include/download-deps.sh

	# build everything mpv depends on (but not mpv itself)
	for x in ${dep_mpv[@]}; do
		echo "==> Building $x"
		./buildall.sh --arch armv7l $x
		./buildall.sh --arch arm64 $x
		./buildall.sh --arch x86 $x
		./buildall.sh --arch x86_64 $x
	done

	if [ -n "$GITHUB_TOKEN" ]; then
		echo "==> Compressing the prefix"
		tar -cvzf $travis_tarball -C prefix .

		echo "==> Uploading the prefix"
		curl -H "Authorization: token $GITHUB_TOKEN" -H "Content-Type: application/x-gzip" --data-binary @$travis_tarball \
			"https://uploads.github.com/repos/hatharry/prebuilt-prefixes/releases/12947922/assets?name=$travis_tarball"
	fi
}

export WGET="wget --progress=bar:force"

if [ "$1" == "install" ]; then
	echo "==> Fetching SDK + NDK"
	TRAVIS=1 ./include/download-sdk.sh

	echo "==> Fetching mpv"
	mkdir -p deps/mpv
	$WGET https://github.com/mpv-player/mpv/archive/${v_mpv}.tar.gz -O ${v_mpv}.tgz
	tar -xzf ${v_mpv}.tgz -C deps/mpv --strip-components=1 && rm ${v_mpv}.tgz

	echo "==> Trying to fetch existing prefix"
	mkdir -p prefix
	(
		$WGET "https://github.com/hatharry/prebuilt-prefixes/releases/download/prefixes/$travis_tarball" -O prefix.tgz \
		&& tar -xzf prefix.tgz -C prefix && rm prefix.tgz
	) || build_prefix
	exit 0
elif [ "$1" == "build" ]; then
	:
else
	exit 1
fi

echo "==> Building mpv armv7l"
./buildall.sh --no-deps --arch armv7l mpv || {
	# show logfile if configure failed
	[ ! -f deps/mpv/_build/config.h ] && cat deps/mpv/_build/config.log
	exit 1
}
echo "==> Building mpv arm64"
./buildall.sh --no-deps --arch arm64 mpv || {
	# show logfile if configure failed
	[ ! -f deps/mpv/_build-arm64/config.h ] && cat deps/mpv/_build-arm64/config.log
	exit 1
}
echo "==> Building mpv x86"
./buildall.sh --no-deps --arch x86 mpv || {
	# show logfile if configure failed
	[ ! -f deps/mpv/_build-x86/config.h ] && cat deps/mpv/_build-x86/config.log
	exit 1
}
echo "==> Building mpv x86_64"
./buildall.sh --no-deps --arch x86_64 mpv || {
	# show logfile if configure failed
	[ ! -f deps/mpv/_build-x64/config.h ] && cat deps/mpv/_build-x64/config.log
	exit 1
}

echo "==> Building mpv-android"
./buildall.sh --no-deps

echo "==> Compressing the jar"
pushd ../app/build/intermediates/javac/debug/classes/
zip -r -9 ../../../../outputs/libmpv_all.jar is/xyz/mpv
popd

pushd ../app/build/tmp/kotlin-classes/debug/
zip -r -9 ../../../outputs/libmpv_all.jar is/xyz/mpv/
popd

pushd ../app/build/outputs
cp libmpv_all.jar libmpv_arm.jar
cp libmpv_all.jar libmpv_x86.jar
popd

pushd ../app/src/main/
mv libs lib
zip -r -9 ../../build/outputs/libmpv_all.jar lib
zip -r -9 ../../build/outputs/libmpv_arm.jar lib/armeabi-v7a
zip -r -9 ../../build/outputs/libmpv_x86.jar lib/x86
mv lib libs
popd

#echo "==> Uploading the .apk"
#curl --upload-file '../app/build/outputs/apk/debug/app-debug.apk' https://transfer.sh/app-debug.apk

#echo "==> Uploading the libmpv_all.jar"
#curl --upload-file '../app/build/outputs/libmpv_all.jar' https://transfer.sh/libmpv_all.jar

#echo "==> Uploading the libmpv_arm.jar"
#curl --upload-file '../app/build/outputs/libmpv_arm.jar' https://transfer.sh/libmpv_arm.jar

#echo "==> Uploading the libmpv_x86.jar"
#curl --upload-file '../app/build/outputs/libmpv_x86.jar' https://transfer.sh/libmpv_x86.jar
exit 0
