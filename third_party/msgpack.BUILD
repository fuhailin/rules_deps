# vim: ft=bzl
load("@rules_cc//cc:defs.bzl", "cc_library")

cc_library(
    name = "msgpack",
    hdrs = glob([
        "include/**/*.(h|hpp)",
    ]),
    includes = ["include"],
    visibility = ["//visibility:public"],
)
