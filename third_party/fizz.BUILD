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
    name = "fizz",
    srcs = glob(
        ["fizz/**/*.cpp"],
        exclude = [
            "fizz/**/test/**/*.cpp",
            "fizz/tool/**",
            "fizz/**/javacrypto/**/*.cpp",
        ],
    ),
    hdrs = glob(["fizz/**/*.h"]),
    copts = DEFAULT_CPP_COPTS,
    includes = ["."],
    visibility = ["//visibility:public"],
    deps = [
        "@com_github_facebook_folly//:folly",
        "@com_github_facebook_zstd//:zstd",
        "@com_github_google_brotli//:brotlidec",
        "@com_github_google_brotli//:brotlienc",
        "@com_github_jedisct1_libsodium//:sodium",
    ],
)
