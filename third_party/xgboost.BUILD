load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "xgboost",
    build_args = [
        "-j `nproc`",
    ],
    lib_source = ":all_srcs",
    # cache_entries = {
    #     # Workaround for the issue with statically linked libstdc++
    #     # using -l:libstdc++.a.
    #     "CMAKE_CXX_FLAGS": "-lstdc++",
    #     "ARROW_CXX_COMPILER_FLAGS": "-lstdc++",
    # },
    linkopts = [
        "-pthread",
    ],
    out_shared_libs = ["libxgboost.so"],
    out_static_libs = ["libdmlc.a"],
    deps = [
        "@com_github_dmlc_dmlc-core//:dmlc-core",
    ],
)
