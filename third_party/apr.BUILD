load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# I tested and this builds only for me on Linux
configure_make(
    name = "apr",
    args = [
        "-j `nproc`",
    ],
    # configure_env_vars = {
    #     "AR": "",
    # },
    configure_options = [
        "--enable-shared=no",
        "--with-pic",
    ],
    lib_source = ":all_srcs",
    out_static_libs = ["libapr-1.a"],
)
