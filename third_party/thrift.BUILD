load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")
load("@rules_flex//flex:flex.bzl", "flex")
load("@//tensorflow:copts.bzl", "DEFAULT_CPP_COPTS", "DEFAULT_LINKOPTS")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # Apache 2.0

exports_files(["LICENSE"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "thrift",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_COMPILER": "OFF",
        "BUILD_CPP": "ON",
        "BUILD_LIBRARIES": "ON",
        "BUILD_NODEJS": "OFF",
        "BUILD_PYTHON": "OFF",
        "BUILD_JAVASCRIPT": "OFF",
        "BUILD_C_GLIB": "OFF",
        "BUILD_JAVA": "OFF",
        "BUILD_TESTING": "OFF",
        "BUILD_TUTORIALS": "OFF",
        "WITH_HASKELL": "OFF",
    },
    lib_source = ":all_srcs",
    # copts = [
    #     "-Ilibs/exporters/jaeger/openssl/include",
    # ],
    # out_binaries = ["thriftc"],
    out_static_libs = [
        "libthrift.a",
        "libthriftnb.a",
        "libthriftz.a",
    ],
    deps = [
        "@boost",
        "@libevent",
    ],
)

flex(
    name = "thriftl",
    src = "thrift/compiler/parse/thriftl.ll",
)

genrule(
    name = "thrifty",
    srcs = ["thrift/compiler/parse/thrifty.yy"],
    outs = [
        "thrift/compiler/parse/thrifty.hh",
        "thrift/compiler/parse/thrifty.cc",
        "thrift/compiler/parse/location.hh",
    ],
    cmd = """
export M4=$(M4)
$(BISON) --skeleton=lalr1.cc --language=c++ $(SRCS) -o $$(dirname $(location thrift/compiler/parse/thrifty.hh))/thrifty.cc
""",
    toolchains = [
        "@rules_bison//bison:current_bison_toolchain",
        "@rules_m4//m4:current_m4_toolchain",
    ],
)

cc_binary(
    name = "compiler_generate_build_templates",
    srcs = ["thrift/compiler/generate/build_templates.cc"],
    copts = DEFAULT_CPP_COPTS,
    deps = ["@boost"],
)

genrule(
    name = "templates_cc",
    srcs = [":templates_files"],
    outs = ["templates.cc"],
    cmd = "$(location :compiler_generate_build_templates) external/com_github_facebook_fbthrift/thrift/compiler/generate/templates >$@",
    tools = [":compiler_generate_build_templates"],
)

cc_binary(
    name = "thriftc",
    srcs = glob(
        [
            "thrift/compiler/**/*.h",
            "thrift/compiler/**/*.cc",
            "thrift/compiler/**/*.cpp",
        ],
        exclude = [
            "thrift/compiler/**/test/**",
            "thrift/compiler/**/example/**",
            "thrift/compiler/**/benchmark/**",
            "thrift/compiler/codemod/**",
            "thrift/compiler/generate/build_templates.cc",
        ],
    ) + [
        ":thriftl",
        ":thrifty",
        ":templates_cc",
    ],
    copts = DEFAULT_CPP_COPTS + [
        "-DTHRIFTY_HH=<thrift/compiler/parse/thrifty.hh>",
        "-DTHRIFT_HAVE_LIBSNAPPY=0",
    ],
    includes = ["."],
    linkopts = DEFAULT_LINKOPTS,  #+ ["-static"],
    visibility = ["//visibility:public"],
    deps = ["@com_github_facebook_folly//:folly"],
)
