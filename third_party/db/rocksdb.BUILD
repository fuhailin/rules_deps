load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# make(
#     name = "rocksdb",
#     args = [
#         "-j `nproc`",
#     ],
#     env = {
#         "ROCKSDB_DISABLE_ZLIB": "1",
#         "ROCKSDB_DISABLE_BZIP": "1",
#         # Solution for https://github.com/bazelbuild/rules_foreign_cc/issues/185
#         "AR": "/usr/bin/ar",
#     },
#     lib_source = ":all_srcs",
#     linkopts = ["-ldl"],
#     # out_include_dir = "external/com_github_facebook_rocksdb/include/rocksdb",
#     # out_lib_dir = "",
#     out_static_libs = ["librocksdb.a"],
#     postfix_script = "mv $EXT_BUILD_ROOT/external/com_github_facebook_rocksdb/librocksdb.a $INSTALLDIR/lib/ && mv $EXT_BUILD_ROOT/external/com_github_facebook_rocksdb/include/rocksdb $INSTALLDIR/include/",
#     targets = [
#         "static_lib",
#     ],
#     deps = [
#         "@com_github_gflags_gflags//:gflags",
#         "@org_bzip_bzip2//:bzip2",
#         # "@com_google_googletest//:gtest",
#         "@lz4",
#         "@com_github_google_snappy//:snappy",
#         "@zlib",
#         # "@com_github_facebook_zstd//:zstd",
#     ],
# )

cmake(
    name = "rocksdb",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "ROCKSDB_BUILD_SHARED": "OFF",
        "WITH_GFLAGS": "ON",
        "WITH_JEMALLOC": "OFF",
        "WITH_LIBURING": "OFF",
        "WITH_SNAPPY": "ON",
        "WITH_LZ4": "OFF",
        "WITH_ZLIB": "ON",
        "WITH_ZSTD": "OFF",
        # "ZSTD_LIBRARIES": "$EXT_BUILD_DEPS/openblas/lib/libopenblas.a",

        # Turning off building tests and benchmarks as those would
        # requires first pulling down those git submodules (which
        # would also require using 'git_repository' instead of
        # 'http_archive'.
        "WITH_TESTS": "OFF",
        "WITH_BENCHMARK_TOOLS": "OFF",
        "WITH_JNI": "OFF",
    },
    lib_source = ":all_srcs",
    linkopts = ["-lpthread"],
    out_static_libs = ["librocksdb.a"],
    deps = [
        "@zlib",
        # "@lz4",
        # "@jemalloc",
        "@com_github_gflags_gflags//:gflags",
        # "@com_github_facebook_zstd//:zstd",
        # "@com_google_googletest//:gtest",
        "@com_github_google_snappy//:snappy",
    ],
)
