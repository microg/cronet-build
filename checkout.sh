#!/bin/bash
# SPDX-FileCopyrightText: 2021, microG Project Team
# SPDX-License-Identifier: Apache-2.0

CHROMIUM_TAG=92.0.4509.1
CHROMIUM_REVISION=0d13b24e08018afd3e9eabcc9ba9820d10cd18a0

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
git fetch -q --depth=1 origin "$CHROMIUM_REVISION"
git checkout --detach "$CHROMIUM_REVISION"
git checkout "$CHROMIUM_REVISION"

echo "## Running gclient sync..."
gclient sync --no-history --nohooks --revision=$CHROMIUM_REVISION
