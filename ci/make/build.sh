#!/usr/bin/env bash

set -o errexit -o nounset

if [[ "$1" == "" ]]; then echo "missing project root"; exit 1; fi

cd "$1"
docker build -f ci/Dockerfile -t thulioassis/opensuse-minikube-image-ci .
