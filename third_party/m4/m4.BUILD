load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# I tested and this builds for me on Linux, did not work MAC
configure_make(
    name = "m4",
    args = [
        "-j `nproc`",
    ],
    configure_options = [
        "--disable-nls",
    ],
    env = {
        "AR": "",
    },
    lib_source = ":all_srcs",
    out_binaries = [
        "m4",
    ],
)
