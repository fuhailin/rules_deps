load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# cmake(
#     name = "fmt",
#     build_args = [
#         "--verbose",
#         "-j `nproc`",
#     ],
#     defines = ["FMT_HEADER_ONLY"],
#     lib_source = "@com_github_fmtlib_fmt//:all_srcs",
#     out_headers_only = True,
# )

cc_library(
    name = "fmt",
    hdrs = glob(["include/fmt/*.h"]),
    defines = ["FMT_HEADER_ONLY"],
    includes = ["include"],
)
