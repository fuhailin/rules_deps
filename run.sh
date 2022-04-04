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
# ./configure &&
bazel build --config=clang \
    //:build_test \
    //:build_test_linux
