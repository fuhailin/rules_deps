load("@rules_foreign_cc//foreign_cc:defs.bzl", "make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(
        [
            "**/*",
        ],
        # exclude = [
        #     "**/BUILD",
        #     "**/WORKSPACE",
        #     "**/LICENSE",
        #     "**/*.zip",
        # ],
    ),
)

make(
    name = "rocksdb",
    args = [
        "-j `nproc`",
    ],
    env = {
        "ROCKSDB_DISABLE_ZLIB": "1",
        "ROCKSDB_DISABLE_BZIP": "1",
        # Solution for https://github.com/bazelbuild/rules_foreign_cc/issues/185
        "AR": "/usr/bin/ar",
    },
    lib_source = ":all_srcs",
    linkopts = ["-ldl"],
    # out_include_dir = "external/com_github_facebook_rocksdb/include/rocksdb",
    # out_lib_dir = "",
    out_static_libs = ["librocksdb.a"],
    postfix_script = "mv $EXT_BUILD_ROOT/external/com_github_facebook_rocksdb/librocksdb.a $INSTALLDIR/lib/ && mv $EXT_BUILD_ROOT/external/com_github_facebook_rocksdb/include/rocksdb $INSTALLDIR/include/",
    targets = [
        "static_lib",
    ],
    deps = [
        "@com_github_gflags_gflags//:gflags",
        "@bzip2",
        # "@com_google_googletest//:gtest",
        "@lz4",
        "@snappy",
        "@zlib",
        # "@zstd",
    ],
)
