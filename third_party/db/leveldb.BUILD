load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "leveldb",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        # Turning off building tests and benchmarks as those would
        # requires first pulling down those git submodules (which
        # would also require using 'git_repository' instead of
        # 'http_archive'.
        "LEVELDB_BUILD_TESTS": "OFF",
        "LEVELDB_BUILD_BENCHMARKS": "OFF",
        # "HAVE_SNAPPY": "OFF",
    },
    lib_source = ":all_srcs",
    linkopts = ["-lpthread"],
    out_static_libs = ["libleveldb.a"],
    # deps = [
    #     "@com_google_googletest//:gtest",
    #     "@com_github_google_snappy//:snappy",
    # ],
)
