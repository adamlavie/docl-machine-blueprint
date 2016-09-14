#!/bin/bash
set -e

# remove /tmp/cloudify-ctx/ from python path. this causes module collision
export PYTHONPATH=''
export DOCKER_HOST=172.20.0.1

VENV_PATH=$1
TESTS=$2

echo 'activating venv ' $VENV_PATH
source $VENV_PATH/bin/activate

echo 'running integration tests ' $TESTS
nosetests -s -v --nologcapture $TESTS | tee ~/tests.out
