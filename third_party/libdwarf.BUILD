load("@rules_foreign_cc//foreign_cc:defs.bzl", "configure_make")

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "all_srcs",
    srcs = glob(
        ["**"],
        exclude = ["gcc/**"],
    ),
)

# I tested and this builds only for me on Linux
configure_make(
    name = "libdwarf",
    args = [
        "-j `nproc`",
    ],
    # env = {
    #     "AR": "",
    # },
    configure_command = "./configure",
    # configure_options = [
    #     "--enable-install-libiberty",
    # ],
    includes = ["libdwarf-0"],
    lib_source = ":all_srcs",
    out_static_libs = ["libdwarf.a"],
)
