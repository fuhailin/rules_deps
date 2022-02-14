load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "dmlc-core",
    build_args = [
        "-j `nproc`",
    ],
    lib_source = ":all_srcs",
    linkopts = [
        "-pthread",
    ],
    out_static_libs = ["libdmlc.a"],
)
