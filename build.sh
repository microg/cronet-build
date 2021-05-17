#!/bin/bash

ROOT=$PWD

PATH=$ROOT/depot_tools:$PATH

cd chromium/src

echo "## Running gclient runhooks..."
gclient runhooks

build() {
  ARCH=$1
  EXTRA_ARGS=$2

  # Copied from the output of ./components/cronet/tools/cr_cronet.py.
  # cr_cronet.py itself doesn't support building obscure architectures like arm64.
  GN_ARGS="
      target_os=\"android\"
      enable_websockets=false
      disable_file_support=true
      disable_ftp_support=true
      disable_brotli_filter=false
      is_component_build=false
      use_crash_key_stubs=true
      ignore_elf32_limitations=true
      use_partition_alloc=false
      include_transport_security_state_preload_list=false
      is_debug=false is_official_build=true
      use_platform_icu_alternatives=true
      use_errorprone_java_compiler=true
      enable_reporting=true
      use_hashed_jni_names=true
  "
  gn gen "out/Release-$ARCH" --args="$GN_ARGS target_cpu=\"$ARCH\" $EXTRA_ARGS"
  ninja -C "out/Release-$ARCH" cronet_package
}

echo "## Building arm..."
build arm arm_use_neon=false

echo "## Building arm64..."
build arm64 arm_use_neon=false

echo "## Building x86..."
build x86

echo "## Building x64..."
build x64
