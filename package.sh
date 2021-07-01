#!/bin/bash
# SPDX-FileCopyrightText: 2021, microG Project Team
# SPDX-License-Identifier: Apache-2.0

rm -f package/cronet-api/libs/*.jar
cp chromium/src/out/Release-x64/cronet/cronet_api.jar package/cronet-api/libs

rm -f package/cronet-common/libs/*.jar
cp chromium/src/out/Release-x64/cronet/cronet_impl_common_java.jar package/cronet-common/libs

rm -f package/cronet-native/libs/*.jar
cp chromium/src/out/Release-x64/cronet/cronet_impl_native_java.jar package/cronet-native/libs

rm -f package/cronet-native/src/main/jniLibs/*/*.so
cp -r chromium/src/out/Release-arm64/cronet/libs/arm64-v8a package/cronet-native/src/main/jniLibs
cp -r chromium/src/out/Release-arm/cronet/libs/armeabi-v7a package/cronet-native/src/main/jniLibs
cp -r chromium/src/out/Release-x64/cronet/libs/x86_64 package/cronet-native/src/main/jniLibs
cp -r chromium/src/out/Release-x86/cronet/libs/x86 package/cronet-native/src/main/jniLibs

cd package
./gradlew build
