load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(
        ["**"],
        exclude = ["gcc/**"],
    ),
)

configure_make(
    name = "libiberty",
    configure_command = "./libiberty/configure",
    configure_options = [
        "--enable-install-libiberty",
    ],
    includes = ["libiberty"],
    lib_source = ":all_srcs",
    out_static_libs = ["libiberty.a"],
)
