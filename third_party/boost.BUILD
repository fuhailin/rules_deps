load("@rules_foreign_cc//foreign_cc:defs.bzl", "boost_build")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

LIBS = [
    # keep sorted
    "atomic",
    "chrono",
    "container",
    "context",
    "contract",
    "coroutine",
    "date_time",
    "exception",
    "fiber",
    "filesystem",
    "graph",
    # "graph_parallel",
    # "headers",
    "iostreams",
    "json",
    "locale",
    "log",
    # "math",
    # "mpi",
    "nowide",
    "program_options",
    # "python",
    "random",
    "regex",
    "serialization",
    # "stacktrace",
    "system",
    # "test",
    "thread",
    "timer",
    "type_erasure",
    "wave",
]

# boost_build(
#     name = "headers",
#     headers_only = True,
#     lib_source = ":all",
#     user_options = [
#         "-j`nproc`",
#         "--with-headers",
#     ],
#     visibility = ["//visibility:public"],
# )

boost_build(
    name = "boost",
    # bootstrap_options = [
    #     "--without-icu",
    # ],
    lib_source = ":all_srcs",
    out_static_libs = ["libboost_{}.a".format(lib) for lib in LIBS],
    user_options = [
        "-j`nproc`",
        "link=static",
        "runtime-link=static",
        # "variant=release",
        # "threading=multi",
    ],
    visibility = ["//visibility:public"],
)

[
    boost_build(
        name = LIB,
        lib_source = ":all_srcs",
        out_static_libs = ["libboost_{}.a".format(LIB)],
        user_options = [
            "-j`nproc`",
            "--with-{}".format(LIB),
        ],
        deps = [
            "@com_github_facebook_zstd//:zstd",
            "@com_github_google_snappy//:snappy",
            "@lz4",
            "@org_bzip_bzip2//:bzip2",
            "@org_lzma_lzma//:lzma",
            "@zlib",
        ],
    )
    for LIB in LIBS
]
