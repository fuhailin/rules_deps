package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # # BSD 3-Clause

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cc_library(
    name = "dense_hash_map",
    hdrs = glob([
        "sparsehash/**",
    ]),
    includes = ["."],
)
