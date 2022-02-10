load("@rules_cc//cc:defs.bzl", "cc_library")
load("@org_tensorflow//tensorflow:copts.bzl", "DEFAULT_C_COPTS")

cc_library(
    name = "xxhash",
    srcs = ["xxhash.c"],
    hdrs = [
        "xxh3.h",
        "xxhash.h",
    ],
    copts = DEFAULT_C_COPTS,
    includes = ["."],
    visibility = ["//visibility:public"],
)
