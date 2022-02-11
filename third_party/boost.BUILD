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
    "iostreams",
    "json",
    "locale",
    "log",
    "log_setup",
    "math_c99",
    "math_c99f",
    "math_c99l",
    "math_tr1",
    "math_tr1f",
    "math_tr1l",
    "nowide",
    "prg_exec_monitor",
    "program_options",
    "random",
    "regex",
    "serialization",
    "stacktrace_addr2line",
    "stacktrace_backtrace",
    "stacktrace_basic",
    "stacktrace_noop",
    "system",
    "test_exec_monitor",
    "thread",
    "timer",
    "type_erasure",
    "unit_test_framework",
    "wave",
    "wserialization",
]

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

boost_build(
    name = "iostreams",
    lib_source = ":all_srcs",
    out_static_libs = ["libboost_iostreams.a"],
    user_options = [
        "-j`nproc`",
        "--with-iostreams",
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
