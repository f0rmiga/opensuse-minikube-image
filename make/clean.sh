#!/usr/bin/env bash

set -o errexit -o nounset

OUTPUT="${1}"

echo -e "Going to remove: ${OUTPUT}"
read -p "Proceed? [yN] " proceed

if [[ "${proceed}" == "y" ]]; then
  sudo rm -rf "${OUTPUT}"
fi
