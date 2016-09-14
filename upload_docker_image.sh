#!/bin/bash
set -e

SECRET_KEY=$1
ACCESS_KEY=$2

sed -i "s~secret_key = XXX~secret_key = $SECRET_KEY~g" ~/.s3cfg
sed -i "s~access_key = XXX~access_key = $ACCESS_KEY~g" ~/.s3cfg

export DOCKER_HOST=172.20.0.1

set -x

echo creating image tar.gz..
docker save cloudify/centos-manager:7 | gzip > manager.tar.gz
pushd ~/repos/cloudify-manager-blueprints
    git rev-parse HEAD >> ~/image.sha1
popd

echo uploading docker image..
s3cmd put --acl-public manager.tar.gz s3://cloudify-tests-files/docl-images/docl-manager.tar.gz
s3cmd put --acl-public ~/image.sha1 s3://cloudify-tests-files/docl-images/docl-manager.sha1
