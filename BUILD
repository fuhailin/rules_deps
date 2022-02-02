load("@bazel_skylib//lib:selects.bzl", "selects")
load("@bazel_skylib//rules:common_settings.bzl", "bool_flag")
load("@bazel_skylib//rules:build_test.bzl", "build_test")

package(default_visibility = ["//visibility:public"])

exports_files([
    "configure",
    "configure.py",
    "ACKNOWLEDGEMENTS",
    "LICENSE",
])

licenses(["notice"])  # Apache 2.0

package(default_visibility = ["//visibility:public"])

build_test(
    name = "build_test",
    targets = [
        "@mkl_dnn_v1//:mkl_dnn",
        "@com_github_jupp0r_prometheus_cpp//push",
        "@rapidjson//:rapidjson",
        "@libevent//:libevent",
        "@com_google_absl//absl/strings",
        "@nlohmann_json_lib//:nlohmann_json",
        "@com_github_grpc_grpc//:grpc",
        "@com_github_grpc_grpc//:grpc++",
        "@openssl//:openssl",
        "@zeromq//:libzmq",
        "@com_github_jupp0r_prometheus_cpp//pull",
        "@com_google_protobuf//:protobuf_lite",
        "@com_google_protobuf//:protobuf",
        "@com_google_protobuf//:protoc_lib",
        "@com_google_protobuf//:protoc",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/types:span",
        "@llvm-project//llvm:Support",
        "@llvm-project//mlir:IR",
        "@llvm-project//mlir:Pass",
        "@llvm-project//mlir:Support",
        "@llvm-project//mlir:Transforms",
        "@flatbuffers",
        "@snappy",
        "@boringssl//:crypto",
        "@jsoncpp_git//:jsoncpp",
        "@com_googlesource_code_re2//:re2",
        "@farmhash_archive//:farmhash",
        "@fft2d",
        "@highwayhash//:sip_hash",
        "@zlib",
        "@gif",
        "@six_archive//:six",
        "@pybind11",
        "@eigen_archive//:eigen3",
        "@eigen_archive//:eigen_header_files",
        "@com_github_gflags_gflags//:gflags",
        "@com_github_google_glog//:glog",
        "@com_github_google_double_conversion//:double-conversion",
        "@lz4",
        "@org_lzma_lzma//:lzma",
        "@zstd//:zstd",
        "@ps-lite//:ps-lite",
        "@rules_compressor//example:zlib_usage_example",
    ],
)

# "@apache_apr//:apr",
# "@apache_aprutil//:aprutil",
# "@apache_log4cxx//:log4cxx",
# "@oneDNN//:mkldnn",
# "@com_github_facebook_rocksdb//:rocksdb",
# "@curl",
# "@cppunit//:cppunit",
# "@cpp3rd_lib//zookeeper:zookeeper",
# "@cpp3rd_lib//zk_client:zk_client",
# "@cpp3rd_lib//tensorflow:tensorflow_cc",
# "@cpp3rd_lib//tensorflow:tensorflow_framework",
