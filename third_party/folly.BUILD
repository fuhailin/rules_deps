load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "folly",
    build_args = [
        # "--verbose",
        "-j `nproc`",
    ],
    # env_vars = {
    #     "Boost_INCLUDE_DIR": "$EXT_BUILD_DEPS/include/",
    #     # "Boost_INCLUDE_DIR": "$$EXT_BUILD_DEPS$$",
    # },
    cache_entries = {
        # "CMAKE_INCLUDE_PATH": "$EXT_BUILD_DEPS/include/:$EXT_BUILD_DEPS/include/boost/",
        # "CMAKE_LIBRARY_PATH": "$EXT_BUILD_DEPS/lib/:$EXT_BUILD_DEPS/include/",
        "DOUBLE_CONVERSION_INCLUDE_DIR": "$EXT_BUILD_DEPS/include/",
        "LIBEVENT_INCLUDE_DIR": "$EXT_BUILD_DEPS/libevent/",
        "BUILD_TESTS": "OFF",
        "LibEvent_FOUND": "OFF",
    },
    copts = [
        "-fPIC",
        "-faligned-new",
        "-fopenmp",
        "-Wall",
        "-Wno-deprecated",
        "-Wno-deprecated-declarations",
        "-Wno-sign-compare",
        "-Wno-unused",
        "-Wunused-label",
        "-Wunused-result",
        "-Wshadow-compatible-local",
        "-Wno-noexcept-type",
        "-std=gnu++14",
    ] + select({
        "@platforms//os:linux": ["-mpclmul"],
        "//conditions:default": [],
    }),
    lib_source = ":all_srcs",
    linkopts = [
        "-pthread",
        "-ldl",
    ],
    # linkstatic = True,
    deps = [
        "@boost",
        "@com_github_fmtlib_fmt//:fmt",
        "@com_github_gflags_gflags//:gflags",
        "@com_github_google_double_conversion//:double-conversion",
        "@com_github_google_glog//:glog",
        "@jemalloc",
        "@libevent",
        "@liburing",
        "@lz4",
        "@openssl",
        "@snappy",
        "@org_lzma_lzma//:lzma",
        "@zlib",
        "@zstd",
    ],
)
