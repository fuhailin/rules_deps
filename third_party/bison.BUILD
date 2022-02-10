load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

# I tested and this builds for me on MAC and Linux, did not check Windows thouigh
configure_make(
    name = "bison",
    args = [
        "-j `nproc`",
    ],
    env = {
        "AR": "",
    },
    lib_source = ":all_srcs",
    out_binaries = [
        "bison",
        "yacc",
    ],
    out_static_libs = ["liby.a"],
)

genrule(
    name = "yacc_bin",
    srcs = [":bison"],
    outs = ["yacc"],
    cmd = "cp `ls $(locations :bison) | grep /bin/bison$$` $@",
    executable = True,
    visibility = ["//visibility:public"],
)
