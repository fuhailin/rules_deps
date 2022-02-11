load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "terarkdb",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "WITH_TERARK_ZIP": "OFF",
        "WITH_JEMALLOC": "OFF",
        "WITH_TESTS": "OFF",
        "WITH_TOOLS": "OFF",
        "WITH_ZLIB": "OFF",
        "WITH_ZSTD": "OFF",
        "WITH_BZ2": "OFF",
        "WITH_GFLAGS": "OFF",
        "WITH_BOOSTLIB": "OFF",
        "WITH_SNAPPY": "OFF",
        "WITH_LZ4": "OFF",
    },
    lib_source = ":all_srcs",
    out_static_libs = ["libterarkdb.a"],
    postfix_script = "mv $BUILD_TMPDIR/lib/libterarkdb.a $INSTALLDIR/lib/",
    deps = [
        "@com_github_gflags_gflags//:gflags",
        "@org_bzip_bzip2//:bzip2",
        "@jemalloc",
        # "@com_google_googletest//:gtest",
        "@lz4",
        "@com_github_google_snappy//:snappy",
        "@zlib",
        "@com_github_facebook_zstd//:zstd",
    ],
)
