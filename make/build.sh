#!/usr/bin/env bash

set -o errexit -o nounset

DESCRIPTION="${1}"
OUTPUT="${2}"

if [ -z "${DESCRIPTION}" ]; then
  (>&2 echo '$1 (DESCRIPTION) must be set')
  exit 1
fi

if [ -z "${OUTPUT}" ]; then
  (>&2 echo '$2 (OUTPUT) must be set')
  exit 1
fi

sudo kiwi-ng --type iso system build --description "${DESCRIPTION}" --target-dir "${OUTPUT}"
