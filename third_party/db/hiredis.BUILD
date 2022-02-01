load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "hiredis",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "BUILD_SHARED_LIBS": "off",
    },
    # generate_args = [
    #     "--enable-shared=no",
    # ],
    lib_source = "@hiredis//:all_srcs",
    out_static_libs = ["libhiredis_static.a"],
    # out_shared_libs = ["libhiredis.1.0.1-dev.dylib"],
)
