# Copyright 2022 Hailin.Fu(hailinfufu@outlook.com).
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

load("@rules_bison//bison:bison.bzl", "bison")
load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_library")
load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")
load("@rules_flex//flex:flex.bzl", "flex")
load("@org_tensorflow//tensorflow:copts.bzl", "DEFAULT_CPP_COPTS", "DEFAULT_LINKOPTS")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

flex(
    name = "thriftl",
    src = "compiler/cpp/src/thrift/thriftl.ll",
)

bison(
    name = "thrifty",
    src = "compiler/cpp/src/thrift/thrifty.yy",
    bison_options = [
        # Note: We cannot require external libraries to conform to specifications
        "-Wno-empty-rule",
    ],
)

genrule(
    name = "copy_thrifty",
    srcs = [":thrifty"],
    outs = [
        "thrift/thrifty.hh",
        "thrift/thrifty.cc",
    ],
    cmd = "mkdir -p $(@D)/thrift && mv $(SRCS) $(@D)/thrift/ && mv $(@D)/thrift/thrifty.h $(@D)/thrift/thrifty.hh",
)

genrule(
    name = "compiler_version",
    srcs = ["compiler/cpp/src/thrift/version.h.in"],
    outs = ["thrift/version.h"],
    cmd = "sed 's/@PACKAGE_VERSION@/0.13.0/g' $< >$@",
)

cc_binary(
    name = "thriftc",
    srcs = glob(
        [
            "compiler/cpp/src/thrift/**/*.h",
            "compiler/cpp/src/thrift/**/*.cc",
            "compiler/cpp/src/thrift/**/*.cpp",
        ],
        exclude = ["compiler/cpp/src/thrift/logging.cc"],
    ) + [
        ":thriftl",
        ":copy_thrifty",
        # Note: begin 0.14.0 thrift needn't generate version
        # ":compiler_version",
    ],
    copts = DEFAULT_CPP_COPTS,
    includes = ["compiler/cpp/src"],
    linkopts = DEFAULT_LINKOPTS + ["-static"],
)

# cc_library(
#     name = "thrift",
#     srcs = glob(
#         [
#             "lib/cpp/src/thrift/**/*.cpp",
#             "lib/cpp/src/thrift/**/*.tcc",
#         ],
#         exclude = [
#             "lib/cpp/src/thrift/windows/**",
#             "lib/cpp/src/thrift/qt/**",
#         ],
#     ),
#     hdrs = glob(["lib/cpp/src/thrift/**/*.h"]),
#     copts = DEFAULT_CPP_COPTS,
#     includes = ["lib/cpp/src"],
#     deps = [
#         "@boost",
#         "@com_github_catchorg_Catch2//:catch2",
#         "@libevent",
#         "@org_tensorflow//third_party/thrift/extra:config",
#         "@zlib",
#     ],
# )

configure_make(
    name = "thrift",
    args = [
        "-j `nproc`",
    ],
    autogen = True,
    autogen_command = "./bootstrap.sh",
    configure_in_place = True,
    configure_options = [
        "--with-boost=no",
        "--with-boost=$EXT_BUILD_DEPS/boost",
    ],
    lib_source = ":all_srcs",
    out_static_libs = [
        "libthrift.a",
        "libthriftnb.a",
        "libthriftz.a",
    ],
    deps = [
        "@boost",
        "@libevent",
    ],
)
