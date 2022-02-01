load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

filegroup(
    name = "all",
    srcs = glob(["**"]),
)

configure_make(
    name = "cityhash",
    args = [
        "-j `nproc`",
    ],
    configure_options = [
        "--enable-shared=no",
    ],
    env = {
        "AR": "",
    },
    install_prefix = "lib",
    lib_source = "@cityhash//:all",
    out_lib_dir = "lib",
    out_static_libs = ["libcityhash.a"],
    visibility = ["//visibility:public"],
)
