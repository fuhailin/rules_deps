"""TensorFlow workspace initialization. Consult the WORKSPACE on how to use it."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")
load("//third_party:tf_runtime/workspace.bzl", tf_runtime = "repo")
load("//third_party/llvm:workspace.bzl", llvm = "repo")

def workspace():
    http_archive(
        name = "io_bazel_rules_closure",
        sha256 = "5b00383d08dd71f28503736db0500b6fb4dda47489ff5fc6bed42557c07c6ba9",
        strip_prefix = "rules_closure-308b05b2419edb5c8ee0471b67a40403df940149",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz",
            "https://github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz",  # 2019-06-13
        ],
    )

    tf_runtime()

    # https://github.com/bazelbuild/bazel-skylib/releases
    http_archive(
        name = "bazel_skylib",
        sha256 = "f7be3474d42aae265405a592bb7da8e171919d74c16f082a5457840f06054728",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
            "https://github.com/bazelbuild/bazel-skylib/releases/download/1.2.1/bazel-skylib-1.2.1.tar.gz",
        ],
    )

    http_archive(
        name = "rules_pkg",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.7.0/rules_pkg-0.7.0.tar.gz",
        ],
        sha256 = "8a298e832762eda1830597d64fe7db58178aa84cd5926d76d5b744d6558941c2",
    )

    http_archive(
        name = "rules_foreign_cc",
        sha256 = "bcd0c5f46a49b85b384906daae41d277b3dc0ff27c7c752cc51e43048a58ec83",
        strip_prefix = "rules_foreign_cc-0.7.1",
        urls = [
            "https://github.com/bazelbuild/rules_foreign_cc/archive/0.7.1.tar.gz",
        ],
    )

    # '''
    git_repository(
        name = "rules_compressor",
        # branch = "main",
        remote = "https://github.com/fuhailin/rules_compressor.git",
        commit = "6e833282f10bfa019eb0f79abfde49c9c099574a",
        # shallow_since = "1644497009 +0800",
    )
    '''
    native.local_repository(
        name = "rules_compressor",
        # path = "/root/projects/rules_compressor",
        path = "/Users/vincent/Documents/projects/rules_compressor",
    )
    # '''

    new_git_repository(
        name = "ps-lite",
        remote = "https://github.com/dmlc/ps-lite",
        commit = "08fb534cd1f58dd3b6a83eba44b508b0eb9a52ce",
        build_file = Label("//third_party:pslite.BUILD"),
    )

    # Load the raw llvm-project.  llvm does not have build rules set up by default,
    # but provides a script for setting up build rules via overlays.
    llvm("llvm-raw")

    # native.local_repository(
    #     name = "cpp3rd_lib",
    #     path = "/root/fuhailin/projects/cpp3rd_lib",
    # )
    # git_repository(
    #     name = "cpp3rd_lib",
    #     commit = "10cec0e759d8048295e3fef6b32273bd455542e7",
    #     remote = "https://gitee.com/fuhailin/cpp3rd_lib.git",
    # )

# Alias so it can be loaded without assigning to a different symbol to prevent
# shadowing previous loads and trigger a buildifier warning.
tf_workspace3 = workspace
