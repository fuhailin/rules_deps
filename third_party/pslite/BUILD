# This BUILD file shows how to use protobuf with bazel. Before you can use
# proto_library/<lang>_proto_library rules in a BUILD file, you need to
# include protobuf repo as remote repositories in your WORKSPACE file. See
# the WORKSPACE file in the same directory with this BUILD file for an
# example.

load("@rules_cc//cc:defs.bzl", "cc_binary", "cc_proto_library")
load("@rules_proto//proto:defs.bzl", "proto_library")

# For each .proto file, a proto_library target should be defined. This target
# is not bound to any particular language. Instead, it defines the dependency
# graph of the .proto files (i.e., proto imports) and serves as the provider
# of .proto source files to the protocol compiler.
#
# Remote repository "com_google_protobuf" must be defined to use this rule.
proto_library(
    name = "meta_proto",
    srcs = ["src/meta.proto"],
    deps = ["@com_google_protobuf//:timestamp_proto"],
)

# The cc_proto_library rule generates C++ code for a proto_library rule. It
# must have exactly one proto_library dependency. If you want to use multiple
# proto_library targets, create a separate cc_proto_library target for each
# of them.
#
# Remote repository "com_google_protobuf_cc" must be defined to use this rule.
cc_proto_library(
    name = "meta_cc_proto",
    deps = [":meta_proto"],
)

cc_library(
    name = "pslite",
    srcs = glob(
        [
            "src/windows/*.h",
            "src/*.h",
            "src/*.cc",
        ],
        # exclude = ["src/main.cpp"],
    ),
    hdrs = glob(
        [
            "include/dmlc/*.h",
            "include/ps/*.h",
        ],
    ),
    visibility = ["//visibility:public"],
    deps = [":meta_cc_proto"],
)
