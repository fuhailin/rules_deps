load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# I tested and this builds only for me on Linux
configure_make(
    name = "sodium",
    args = [
        "-j `nproc`",
    ],
    env = {
        "AR": "",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["libsodium.a"],
)
