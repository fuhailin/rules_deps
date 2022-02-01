load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all",
    srcs = glob(["**"]),
)

# I tested and this builds only for me on Linux
configure_make(
    name = "log4cxx",
    args = [
        "-j `nproc`",
    ],
    autogen = True,
    configure_in_place = True,
    configure_options = [
        "--with-apr=$EXT_BUILD_DEPS/apr",
        "--with-apr-util=$EXT_BUILD_DEPS/aprutil",
    ],
    lib_source = "@apache_log4cxx//:all",
    out_static_libs = ["liblog4cxx.a"],
    # targets = [
    #     "make -j `nproc`",
    #     "make install",
    # ],
    deps = [
        "@apache_apr//:apr",
        "@apache_aprutil//:aprutil",
    ],
)
