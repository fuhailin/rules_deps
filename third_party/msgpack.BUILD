# vim: ft=bzl
load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "msgpack",
    hdrs = glob([
        "include/**/*.(h|hpp)",
    ]),
    includes = ["include"],
    deps = [
        "@boost",
    ],
)
