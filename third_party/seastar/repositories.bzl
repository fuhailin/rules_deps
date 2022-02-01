"""A module defining the third party dependency abseil"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def repo(COMMIT = "19.06.0"):
    maybe(
        http_archive,
        name = "seastar",
        urls = [
            "https://github.com.cnpmjs.org/scylladb/seastar/archive/seastar-{}.tar.gz".format(COMMIT),
        ],
        strip_prefix = "seastar-seastar-" + COMMIT,
        build_file = Label("//third_party/seastar:seastar.BUILD"),
        patch_args = ["-p1"],
        patches = ["//third_party/seastar:seastar.patch"],
    )
