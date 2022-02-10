load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# I tested and this builds only for me on Linux
configure_make(
    name = "aprutil",
    args = [
        "-j `nproc`",
    ],
    # env = {
    #     "AR": "",
    # },
    configure_options = [
        "--with-apr=$EXT_BUILD_DEPS/apr",
        "--with-expat=$EXT_BUILD_DEPS/expat",
    ],
    lib_source = ":all_srcs",
    out_static_libs = ["libaprutil-1.a"],
    deps = [
        "@apache_apr//:apr",
        "@libexpat//:expat",
    ],
)
