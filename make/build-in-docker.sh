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

IMAGE_NAME="minikube-opensuse-image-builder"
MOUNTED_DESCRIPTION="/mnt/description"
MOUNTED_OUTPUT="/mnt/output"

mkdir -p "${OUTPUT}"

docker build \
  --build-arg "OUTPUT=${MOUNTED_OUTPUT}" \
  --build-arg "DESCRIPTION=${MOUNTED_DESCRIPTION}" \
  --tag "${IMAGE_NAME}" .

docker run \
  --tty --interactive --rm --privileged \
  --volume "${OUTPUT}:${MOUNTED_OUTPUT}" \
  --volume "${DESCRIPTION}:${MOUNTED_DESCRIPTION}" \
  "${IMAGE_NAME}"
