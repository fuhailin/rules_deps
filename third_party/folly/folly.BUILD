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

cc_library(
    name = "folly",
    srcs = glob(
        ["folly/**/*.cpp"],
        exclude = [
            "folly/**/test/**",
            "folly/**/example/**",
            "folly/python/**",
            "folly/tools/**",
            "folly/experimental/exception_tracer/**",
            "folly/experimental/TestUtil.cpp",
            "folly/experimental/io/HugePageUtil.cpp",
            "folly/experimental/JSONSchemaTester.cpp",
        ],
    ),
    hdrs = glob(["folly/**/*.h"]),
    copts = DEFAULT_CPP_COPTS,
    includes = ["."],
    linkopts = [
        "-ldl",
        "-lpthread",
    ],
    visibility = ["//visibility:public"],
    deps = [
        "@boost",
        "@com_github_axboe_liburing//:liburing",
        "@com_github_facebook_zstd//:zstd",
        "@com_github_fmtlib_fmt//:fmt",
        "@com_github_google_double_conversion//:double-conversion",
        "@com_github_google_glog//:glog",
        "@com_github_google_snappy//:snappy",
        "@com_github_jedisct1_libsodium//:sodium",
        "@com_google_googletest//:gtest",
        "@com_pagure_libaio//:libaio",
        "@libdwarf",
        "@libevent",
        "@libiberty",
        "@libunwind",
        "@openssl",
        "@org_bzip_bzip2//:bzip2",
        "@org_lzma_lzma//:lzma",
        "@org_tensorflow//third_party/folly/extra:config",
        "@zlib",
    ],
)
