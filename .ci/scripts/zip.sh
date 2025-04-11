#!/usr/bin/env bash

#  Copyright (c) Juniper Networks, Inc., 2025-2025.
#  All rights reserved.
#  SPDX-License-Identifier: MIT

set -euf -o pipefail

BUILD_DIR=/tmp/build

if ! [[ "$GITHUB_REF_TYPE" == "tag" ]]
then
  echo "GITHUB_REF_TYPE is $GITHUB_REF_TYPE"
  echo "not generating a release"
  exit 1
fi

if ! [[ "$GITHUB_REF_NAME" =~ ^v[0-9]+\.[0-9]+\.[0-9]+$ ]]
then
  echo "tag is $GITHUB_REF_NAME"
  echo "not generating a release"
  exit 2
fi

TMPDIR=$(mktemp -d)

[ -e LICENSE ] && cp LICENSE $TMPDIR
[ -e LICENSE.txt ] && cp LICENSE.txt $TMPDIR
[ -e pack/README.md ] && cp pack/README.md $TMPDIR
[ -d pack/tofu ] && cp -r pack/tofu $TMPDIR

mkdir -p "$BUILD_DIR"

ZIP_FILE_NAME="$BUILD_DIR/${GITHUB_REPOSITORY/\//__}__${GITHUB_REF_NAME}.zip"
(cd "$TMPDIR"; zip -r "$ZIP_FILE_NAME" .)

echo "ZIP_FILE_NAME=${ZIP_FILE_NAME}" >> "$GITHUB_ENV"

echo "contents of $BUILD_DIR"
ls -l "$BUILD_DIR"

