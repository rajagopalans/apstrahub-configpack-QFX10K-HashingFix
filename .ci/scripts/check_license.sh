#!/usr/bin/env bash

#  Copyright (c) Juniper Networks, Inc., 2025-2025.
#  All rights reserved.
#  SPDX-License-Identifier: MIT

set -euf -o pipefail

GIT_ROOT="$(git rev-parse --show-toplevel)"
LICENSE_FILE="${GIT_ROOT}/LICENSE"

if [ ! -r "$LICENSE_FILE" ]
then
  LICENSE_FILE="${LICENSE_FILE}.txt"
    if [ ! -r "$LICENSE_FILE" ]
    then
      echo "$LICENSE_FILE not found"
      exit 1
  fi
fi

echo LICENSE_FILE found at $LICENSE_FILE

# SHA-256 hash of MIT license with copyright line removed
EXPECTED_SHA256="12aff42bbcb24fe64b0ca46950fb0197dc82386b2dcf24ee47cf0de627992d3d"

# ignore any Copyright lines when calculating the license checksum
ACTUAL_SHA256=$(egrep -v '^$|^Copyright' "$LICENSE_FILE" | shasum -a 256 | awk '{print $1}')

if [[ "$EXPECTED_SHA256" != "$ACTUAL_SHA256"* ]]
then
  echo "$LICENSE_FILE might not be the MIT license"
  exit 2
fi

echo LICENSE_FILE hash is okay

if printenv GITHUB_REPOSITORY_OWNER > /dev/null
then
  if ! egrep "^Copyright \(c\) [0-9]+ $(printenv GITHUB_REPOSITORY_OWNER)$" "$LICENSE_FILE" > /dev/null
  then
    echo "$LICENSE_FILE must contain a line matching: 'Copyright (c) YYYY $(printenv GITHUB_REPOSITORY_OWNER)'"
    exit 3
  fi
fi

echo LICENSE_FILE copyright header matches github repository owner
