"""A module defining the third party dependency liburing"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def repo():
    maybe(
        http_archive,
        name = "liburing",
        build_file = Label("//third_party/liburing:liburing.BUILD"),
        urls = [
            "https://github.com.cnpmjs.org/axboe/liburing/archive/liburing-0.6.tar.gz",
            "https://github.com/axboe/liburing/archive/liburing-0.6.tar.gz"],
        strip_prefix = "liburing-liburing-0.6",
        patch_args = [
            "-p0",
        ],
        patches = [
            Label("//third_party/liburing:liburing.patch"),
        ],
    )
