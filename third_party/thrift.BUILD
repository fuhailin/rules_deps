load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "thrift",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_COMPILER": "OFF",
        "BUILD_CPP": "ON",
        "BUILD_LIBRARIES": "ON",
        "BUILD_NODEJS": "OFF",
        "BUILD_PYTHON": "OFF",
        "BUILD_JAVASCRIPT": "OFF",
        "BUILD_C_GLIB": "OFF",
        "BUILD_JAVA": "OFF",
        "BUILD_TESTING": "OFF",
        "BUILD_TUTORIALS": "OFF",
        "WITH_HASKELL": "OFF",
    },
    # copts = [
    #     "-Ilibs/exporters/jaeger/openssl/include",
    # ],
    lib_source = ":all_srcs",
    out_static_libs = [
        "libthrift.a",
        "libthriftnb.a",
        "libthriftz.a",
    ],
    deps = [
        "@boost",
        "@libevent",
    ],
)
