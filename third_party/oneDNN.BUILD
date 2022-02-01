load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "all",
    srcs = glob(["**"]),
)

# MKL-DNN for conv2d
cmake(
    name = "mkldnn",
    build_args = [
        "--verbose",
        "-j `nproc`",
    ],
    cache_entries = {
        # MKL-DNN's source throws set-but-not-used warnings with -Werror,
        # setting this turns those off
        "MKLDNN_PRODUCT_BUILD_MODE": "OFF",
        "WITH_TEST": "OFF",
        "WITH_EXAMPLE": "OFF",
    },
    lib_source = "all",
    out_shared_libs = select({
        "@platforms//os:macos": [
            "libmkldnn.dylib",
        ],
        "@platforms//os:linux": [
            "libdnnl.so",
            "libmkldnn.so",
        ],
        "@platforms//os:windows": [
            "libmkldnn.dll",
        ],
    }),
    visibility = ["//visibility:public"],
    alwayslink = True,
)
