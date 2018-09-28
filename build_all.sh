#!/usr/bin/env bash

set -ex

DOCKER_USER="kaczmarj"
DOCKER_REPO="ants"

# for version in v2.3.1 v2.3.0 v2.2.0 v2.1.0 v2.0.3 v2.0.2 v2.0.1 v2.0.0; do
for version in v2.2.0; do
  docker build \
    --build-arg NPROC=8 \
    --build-arg ants_version=$version \
    --tag=$DOCKER_USER/$DOCKER_REPO:$version-source - < Dockerfile \
    | tee logs/ANTs-Linux-centos6_x86_64-$version.log
done
