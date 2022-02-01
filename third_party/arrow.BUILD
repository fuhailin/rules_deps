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
        "CMAKE_CXX_FLAGS": "-lstdc++",
        "ARROW_CXX_COMPILER_FLAGS": "-lstdc++",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["libarrow.a"],
    working_directory = "cpp",
    deps = [
        # "@apache_thrift//:thrift",
        # "@boringssl//:crypto",
        # "@brotli",
        # "@bzip2",
        # "@com_github_google_double_conversion//:double-conversion",
        "@jemalloc",
        # "@lz4",
        # "@rapidjson",
        # "@snappy",
        "@xsimd",
        # "@zlib",
        # "@zstd",
    ],
)
