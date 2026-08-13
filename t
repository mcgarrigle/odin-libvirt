#!/usr/bin/bash

clear

# OS variables are global shared state so run tests in single thread
odin test lib/libvirt -collection:project=./lib -all-packages \
  -define:ODIN_TEST_THREADS=1 \
  -define:ODIN_TEST_RANDOM_SEED=1971089818485440 \
  -define:ODIN_TEST_TRACK_MEMORY=false
