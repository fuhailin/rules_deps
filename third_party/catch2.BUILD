load("@rules_cc//cc:defs.bzl", "cc_library")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# cmake(
#     name = "catch2",
#     build_args = [
#         # "--verbose",
#         "-j `nproc`",
#     ],
#     # These options help CMake to find prebuilt OpenBLAS, which will be copied into
#     # $EXT_BUILD_DEPS/openblas by the cmake_external script
#     # cache_entries = {
#     #     "BLAS_VENDOR": "OpenBLAS",
#     #     "BLAS_LIBRARIES": "$EXT_BUILD_DEPS/openblas/lib/libopenblas.a",
#     # },
#     lib_source = ":all_srcs",
#     out_static_libs = [
#         "libCatch2.a",
#         "libCatch2Main.a",
#     ],
#     # linkopts = [
#     #     "-pthread",
#     # ],
#     # out_headers_only = True,
#     # out_include_dir = "include/eigen3",
#     # Dependency on other cmake_external rule; can also depend on cc_import, cc_library rules
#     # deps = ["@openblas"],
# )

defines = ["CATCH_CONFIG_CPP17_STRING_VIEW"]

cc_library(
    name = "catch2",
    srcs = glob(
        ["src/catch2/**/*.cpp"],
        exclude = ["src/catch2/internal/catch_main.cpp"],
    ),
    hdrs = glob(["src/catch2/**/*.hpp"]),
    # copts = DEFAULT_CPP_COPTS,
    copts = [
        "-std=c++17",
    ],
    defines = defines,
    includes = ["src/"],
    linkstatic = True,
    visibility = ["//visibility:public"],
)

cc_library(
    name = "catch2_main",
    srcs = ["src/catch2/internal/catch_main.cpp"],
    # copts = DEFAULT_CPP_COPTS,
    copts = [
        "-std=c++17",
    ],
    defines = defines,
    includes = ["src/"],
    linkstatic = True,
    visibility = ["//visibility:public"],
    deps = [":catch2"],
)
