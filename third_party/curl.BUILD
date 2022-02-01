load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

filegroup(
    name = "all",
    srcs = glob(["**"]),
    visibility = ["//visibility:public"],
)

cmake(
    name = "libcurl",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_TESTING": "OFF",
        "CMAKE_USE_OPENSSL": "FALSE",
        "CURL_DISABLE_LDAP": "TRUE",
    },
    defines = select({
        "@bazel_tools//src/conditions:windows": ["CURL_STATICLIB"],
        "//conditions:default": [],
    }),
    lib_source = "//:all",
    linkopts = select({
        "@bazel_tools//src/conditions:windows": [
            "WS2_32.Lib",
            "Advapi32.lib",
            "Iphlpapi.lib",
            "Userenv.lib",
            "User32.lib",
        ],
        "@bazel_tools//src/conditions:darwin": [],
        "//conditions:default": [
            "-ldl",
            "-lz",
            "-lidn",
        ],
    }),
    out_lib_dir = select({
        "@platforms//os:linux": "lib",
        "//conditions:default": "lib",
    }),
    out_static_libs = select({
        "@bazel_tools//src/conditions:windows": [
            "libcurl.lib",
        ],
        "//conditions:default": ["libcurl.a"],
    }),
    visibility = ["//visibility:public"],
    deps = [
        "@libssh2",
    ],
)

cmake(
    name = "curl",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "CMAKE_BUILD_TYPE": "Release",
        "BUILD_SHARED_LIBS": "OFF",
        "BUILD_TESTING": "OFF",
        "CMAKE_USE_OPENSSL": "TRUE",
        "CURL_DISABLE_LDAP": "TRUE",
        "OPENSSL_ROOT_DIR": "$$EXT_BUILD_DEPS$$/openssl",
    },
    defines = select({
        "@bazel_tools//src/conditions:windows": ["CURL_STATICLIB"],
        "//conditions:default": [],
    }),
    lib_source = "//:all",
    linkopts = select({
        "@bazel_tools//src/conditions:windows": [
            "WS2_32.Lib",
            "Advapi32.lib",
            "Iphlpapi.lib",
            "Userenv.lib",
            "User32.lib",
        ],
        "@bazel_tools//src/conditions:darwin": [],
        "//conditions:default": [
            "-ldl",
            "-lz",
            "-lidn2",
        ],
    }),
    out_lib_dir = select({
        "@platforms//os:linux": "lib",
        "//conditions:default": "lib",
    }),
    out_static_libs = select({
        "@bazel_tools//src/conditions:windows": [
            "libcurl.lib",
        ],
        "//conditions:default": ["libcurl.a"],
    }),
    visibility = ["//visibility:public"],
    deps = [
        "@libssh2",
        "@openssl",
    ],
)
