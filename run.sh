#!/bin/bash

git --version
python --version
pip --version
gcc --version
g++ --version
clang --version
clang++ --version
bazel version

# Build Tensorflow
./configure &&
bazel build \
    //:build_test \
    //:build_test_linux
