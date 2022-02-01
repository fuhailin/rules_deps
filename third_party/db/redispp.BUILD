load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "redispp",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "REDIS_PLUS_PLUS_CXX_STANDARD": "11",
        "REDIS_PLUS_PLUS_BUILD_TEST": "OFF",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["libredis++.a"],
    deps = [
        "@hiredis",
    ],
)
