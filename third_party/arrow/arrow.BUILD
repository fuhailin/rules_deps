load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "arrow",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        # Workaround for the issue with statically linked libstdc++
        # using -l:libstdc++.a.
        # "CMAKE_CXX_FLAGS": "-Dredacted=redacted",
        # "CMAKE_CXX_FLAGS": "-D__DATE__=\"redacted\"",
        "CMAKE_BUILD_TYPE": "Release"
        "ARROW_BUILD_SHARED": "OFF",
        "ARROW_BUILD_STATIC": "ON",
        "ARROW_BUILD_TESTS": "OFF",
        "ARROW_JEMALLOC": "ON",
        "ARROW_JEMALLOC_INCLUDE_DIR": "$EXT_BUILD_DEPS/jemalloc",
        # "ARROW_SIMD_LEVEL": "AVX2",
        # "ARROW_DATASET": "ON",
        # "ARROW_FILESYSTEM": "ON",
        # "ARROW_IPC": "ON",
        # "ARROW_COMPUTE": "ON",
        # "ARROW_CUDA": "OFF",
        # "ARROW_CSV": "ON",
        # "ARROW_JSON": "ON",
        # "ARROW_PARQUET": "ON",
        # "ARROW_WITH_SNAPPY": "OFF",
        # "ARROW_WITH_RE2": "OFF",
        # "ARROW_WITH_UTF8PROC": "OFF",
        # "ARROW_WITH_ZSTD": "ON",
        # "ARROW_TENSORFLOW": "OFF",
        # "ARROW_HDFS": "ON",
        # "__DATE__": "redacted",
    },
    # env = {"CMAKE_CXX_FLAGS": "-Dredacted=\"redacted\""},
    # env = {"CMAKE_CXX_FLAGS": r"""-DDATE='\"redacted\"' -DTIMESTAMP='\"redacted\"' -DTIME='\"redacted\"'"""},
    # env = {"CXXFLAGS": "-Dredacted='\\\"redacted\\\"'"},
    lib_source = ":all_srcs",
    out_static_libs = ["libarrow.a"],
    # out_shared_libs = ["libarrow.so"],
    working_directory = "cpp",
    deps = [
        "@jemalloc",
        # "@com_github_xtensorstack_xsimd//:xsimd",
        # "@apache_thrift//:thrift",
        # "@boringssl//:crypto",
        # "@brotli",
        # "@org_bzip_bzip2//:bzip2",
        # "@com_github_google_double_conversion//:double-conversion",
        # "@jemalloc",
        # "@lz4",
        # "@rapidjson",
        # "@com_github_google_snappy//:snappy",
        # "@xsimd",
        # "@zlib",
        # "@com_github_facebook_zstd//:zstd",
    ],
)
