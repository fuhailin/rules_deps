load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

configure_make(
    name = "cppunit",
    args = [
        "-j `nproc`",
    ],
    autogen = True,
    configure_in_place = True,
    lib_source = ":all_srcs",
    out_shared_libs = select({
        "@platforms//os:macos": [
            "libcppunit.dylib",
        ],
        "@platforms//os:linux": [
            "libcppunit.so",
        ],
        "@platforms//os:windows": [
            "libcppunit.dll",
        ],
    }),
    out_static_libs = ["libcppunit.a"],
)
