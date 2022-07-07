#!/bin/bash
# SPDX-FileCopyrightText: 2021, microG Project Team
# SPDX-License-Identifier: Apache-2.0

CHROMIUM_TAG=102.0.5005.125
CHROMIUM_REVISION=c77ce0c0fc9ea1554d15ff6c72a7670268b128e4

ROOT=$PWD

if ! [ -d depot_tools ]; then
  echo "## Preparing depot_tools..."
  git clone "https://chromium.googlesource.com/chromium/tools/depot_tools.git"
fi

PATH=$ROOT/depot_tools:$PATH

if ! [ -d chromium ]; then
  echo "## Initializing chromium..."
  mkdir chromium
  cd chromium

  gclient config "https://chromium.googlesource.com/chromium/src.git"
  echo 'target_os = ["android"]' >> .gclient

  git init -q src
  cd src
  git remote add -t $CHROMIUM_TAG origin "https://chromium.googlesource.com/chromium/src.git"
fi

cd "$ROOT/chromium/src"

echo "## Fetching chromium..."
# We need to make sure we have the commit with latest Change-Id
git fetch -q --depth=20 origin "$CHROMIUM_REVISION"
git checkout --detach "$CHROMIUM_REVISION"
git checkout "$CHROMIUM_REVISION"

echo "## Running gclient sync..."
gclient sync --no-history --nohooks --revision=$CHROMIUM_REVISION
