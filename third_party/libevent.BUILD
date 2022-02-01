# libevent (libevent.org) library.
# from https://github.com/libevent/libevent
load("@rules_foreign_cc//foreign_cc:defs.bzl", "cmake")

package(
    default_visibility = ["//visibility:public"],
)

licenses(["notice"])  # BSD

exports_files(["LICENSE"])

filegroup(
    name = "all_srcs",
    srcs = glob(["**"]),
)

cmake(
    name = "libevent",
    build_args = [
        "-j `nproc`",
    ],
    cache_entries = {
        "EVENT__DISABLE_OPENSSL": "on",
        "EVENT__DISABLE_MBEDTLS": "on",
        "EVENT__DISABLE_REGRESS": "on",
        "EVENT__DISABLE_TESTS": "on",
        "EVENT__LIBRARY_TYPE": "STATIC",
        # Force _GNU_SOURCE on for Android builds. This would be contained in
        # a 'select' but the downstream macro uses a select on all of these
        # options, and they cannot be nested.
        # If https://github.com/bazelbuild/rules_foreign_cc/issues/289 is fixed
        # this can be removed.
        # More details https://github.com/lyft/envoy-mobile/issues/116
        "_GNU_SOURCE": "on",
    },
    env = select({
        "@platforms//os:macos": {
            "AR": "/usr/bin/ar",
        },
        "//conditions:default": {},
    }),
    lib_source = ":all_srcs",
    out_static_libs = select({
        # macOS organization of libevent is different from Windows/Linux.
        # Including libevent_core is a requirement on those platforms, but
        # results in duplicate symbols when built on macOS.
        # See https://github.com/lyft/envoy-mobile/issues/677 for details.
        "@platforms//os:macos": [
            "libevent.a",
            "libevent_pthreads.a",
        ],
        "@platforms//os:windows": [
            "event.lib",
            "event_core.lib",
        ],
        "//conditions:default": [
            "libevent.a",
            "libevent_pthreads.a",
            "libevent_core.a",
        ],
    }),
)
