# Copyright 2021 curoky(cccuroky@gmail.com).
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

load("@rules_cc//cc:defs.bzl", "cc_library")
load("@org_tensorflow//third_party/fbthrift:copts.bzl", "DEFAULT_CPP_COPTS")

filegroup(
    name = "snappy_stubs_public_h_in",
    srcs = ["snappy-stubs-public.h.in"],
)

genrule(
    name = "snappy_stubs_public_h",
    srcs = [":snappy_stubs_public_h_in"],
    outs = ["snappy-stubs-public.h"],
    cmd = """
    export HAVE_SYS_UIO_H_01=1
    export PROJECT_VERSION_MAJOR=1
    export PROJECT_VERSION_MINOR=1
    export PROJECT_VERSION_PATCH=8
    envsubst < $< > $@
    """,
)

cc_library(
    name = "snappy",
    srcs = glob(
        ["**/*.cc"],
        exclude = [
            "*test*.cc",
            "*fuzzer.cc",
            "snappy_benchmark.cc",
        ],
    ),
    hdrs = glob(["**/*.h"]) + [":snappy_stubs_public_h"],
    copts = DEFAULT_CPP_COPTS,
    defines = ["HAVE_CONFIG_H"],
    includes = ["."],
    visibility = ["//visibility:public"],
    deps = [
        "@org_tensorflow//third_party/snappy/extra:config",
    ],
)
