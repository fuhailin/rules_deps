load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "kafka",
    build_args = [
        "-j `nproc`",
    ],
    # cache_entries = {
    #     "RDKAFKA_BUILD_STATIC": "ON",
    #     "WITH_ZSTD": "OFF",
    #     "WITH_SSL": "OFF",
    #     "WITH_SASL": "OFF",
    #     "ENABLE_LZ4_EXT": "OFF",
    #     "WITH_LIBDL": "OFF",
    #     "WITH_ZLIB": "OFF",
    # },
    lib_source = ":all_srcs",
    out_shared_libs = [
        "librdkafka.so",
        "librdkafka++.so",
        "librdkafka.so.1",
        "librdkafka++.so.1",
    ],
    # deps = ["@zlib"],
)
