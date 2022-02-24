load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")
load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # # BSD 3-Clause

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# cmake(
#     name = "dense_hash_map",
#     build_args = [
#         "-j `nproc`",
#     ],
#     lib_source = ":all_srcs",
#     out_headers_only = True,
# )

cc_library(
    name = "dense_hash_map",
    hdrs = glob([
        "sparsehash/**",
    ]),
    includes = ["."],
)
