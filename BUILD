load("@bazel_skylib//rules:build_test.bzl", "build_test")

package(default_visibility = ["//visibility:public"])

exports_files([
    ".clang-format",
    "configure",
    "configure.py",
    "ACKNOWLEDGEMENTS",
    "LICENSE",
])

licenses(["notice"])  # Apache 2.0

build_test(
    name = "build_test",
    targets = [
        # "@mkl_dnn_v1//:mkl_dnn",
        # "@com_github_jupp0r_prometheus_cpp//push",
        "@com_github_tencent_rapidjson//:rapidjson",
        # "@libevent//:libevent",
        "@com_google_absl//absl/strings",
        "@nlohmann_json_lib//:nlohmann_json",
        "@com_github_grpc_grpc//:grpc",
        "@com_github_grpc_grpc//:grpc++",
        # "@openssl//:openssl",
        # "@zeromq//:libzmq",
        # "@com_github_jupp0r_prometheus_cpp//pull",
        # "@com_google_protobuf//:protobuf_lite",
        "@com_google_protobuf//:protobuf",
        # "@com_google_protobuf//:protoc_lib",
        # "@com_google_protobuf//:protoc",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/types:span",
        # "@llvm-project//llvm:Support",
        # "@llvm-project//mlir:IR",
        # "@llvm-project//mlir:Pass",
        # "@llvm-project//mlir:Support",
        # "@llvm-project//mlir:Transforms",
        "@com_github_google_flatbuffers//:flatbuffers",
        # "@boringssl//:crypto",
        # "@jsoncpp_git//:jsoncpp",
        # "@com_googlesource_code_re2//:re2",
        # "@farmhash_archive//:farmhash",
        # "@fft2d",
        # "@highwayhash//:sip_hash",
        # "@gif",
        # "@six_archive//:six",
        "@pybind11",
        "@com_github_gflags_gflags//:gflags",
        "@com_github_google_glog//:glog",
        "@com_google_googletest//:gtest",
        "@ps-lite//:ps-lite",
        # "@rules_compressor//example:zlib_usage_example",
        "@spdlog",
        "@com_github_fmtlib_fmt//:fmt",
        "@uuid",
        # "@libevent",
        # "@cityhash",
        "@openblas",
        "@eigen",
        # "@com_github_xtensorstack_xsimd//:xsimd",
        # "@org_gnu_bison//:bison",
        # "@org_gnu_bison//:yacc_bin",
        # "@org_gnu_m4//:m4",
        "@org_bzip_bzip2//:bzip2",
        "@lz4",
        "@org_lzma_lzma//:lzma",
        "@com_github_google_snappy//:snappy",
        "@zlib",
        "@com_github_facebook_zstd//:zstd",
        # "@openssl",
        # "@com_github_jedisct1_libsodium//:sodium",
        "@com_github_google_double_conversion//:double-conversion",
        # "@com_pagure_libaio//:libaio",
        # "@libdwarf",
        # "@libunwind",
        # "@com_github_facebook_fatal//:fatal",
        # "@com_github_cyan4973_xxhash//:xxhash",
        # "@rules_m4//m4:current_m4_toolchain",
        # "@rules_bison//bison:current_bison_toolchain",
        # "@boost",
        # "@com_github_catchorg_Catch2//:catch2",
        # "@com_github_catchorg_Catch2//:catch2_main",
        "@com_github_apache_thrift//:thriftl",
        "@com_github_apache_thrift//:copy_thrifty",
        "@com_github_apache_thrift//:thrift",
        "@com_github_apache_thrift//:thriftc",
        # "@com_github_facebook_folly//:folly",
        # "@com_github_facebook_fbthrift//:fbthrift",
        # "@com_github_google_brotli//:brotli",
        "@com_google_benchmark//:benchmark",
        # "@clog",
        # "@cpuinfo",
        # "@dlpack",
    ],
)

build_test(
    name = "build_test_linux",
    targets = [
        "@nlohmann_json_lib//:nlohmann_json",
        "@boost//:boost",

        # "@jemalloc",
        "@llvm-project//clang:clang-format",
        # "@com_github_apache_arrow//:arrow",
        # "@com_github_facebook_zstd//:zstd",
        # "@io_opentelemetry_cpp//:opentelemetry",
        # "@com_github_facebookincubator_fizz//:fizz",
        # "@com_github_facebook_wangle//:wangle",
        # "@com_github_facebook_proxygen//:proxygen",
        # "@com_github_apache_thrift//:thriftl",
        # "@com_github_apache_thrift//:copy_thrifty",
        # "@com_github_apache_thrift//:thrift",
        # "@com_github_apache_thrift//:thriftc",
        # "@com_github_facebook_folly//:folly",
        # "@com_github_facebook_fbthrift//:fbthrift",

        # "@io_opentelemetry_cpp//exporters/ostream:ostream_span_exporter",
        # "@io_opentelemetry_cpp//exporters/otlp:otlp_http_exporter",

        # "@io_opentelemetry_cpp//:common_proto_cc",
        # "@com_github_xtensorstack_xsimd//:xsimd",
        # "@com_github_apache_arrow//:arrow",
        # "@curl",

        # "@io_opentelemetry_cpp//api",
        # "@io_opentelemetry_cpp",
        # "@boringssl//:crypto",
        # "@com_github_facebook_fbthrift//:fbthrift",
        # "@com_github_facebook_zstd//:zstd",
        # "@com_github_google_brotli//:brotli",
        # "@com_github_google_double_conversion//:double-conversion",
        # "@com_github_google_snappy//:snappy",
        # "@com_github_tencent_rapidjson//:rapidjson",
        # "@com_github_xtensor-stack_xsimd//:xsimd",
        # "@lz4",
        # "@org_bzip_bzip2//:bzip2",
        # "@zlib",
    ],
)

build_test(
    name = "build_test_boost",
    targets = [
        "@boost//:boost",
        "@boost//:atomic",
        "@boost//:chrono",
        "@boost//:container",
        "@boost//:context",
        "@boost//:contract",
        "@boost//:coroutine",
        "@boost//:date_time",
        "@boost//:exception",
        "@boost//:fiber",
        "@boost//:filesystem",
        "@boost//:graph",
        "@boost//:graph_parallel",
        "@boost//:headers",
        "@boost//:iostreams",
        "@boost//:json",
        "@boost//:locale",
        "@boost//:log",
        # "@boost//:math",  #libboost_math_c99.a
        "@boost//:mpi",
        "@boost//:nowide",
        "@boost//:program_options",
        "@boost//:python",
        "@boost//:random",
        "@boost//:regex",
        "@boost//:serialization",
        "@boost//:stacktrace",
        "@boost//:system",
        "@boost//:test",
        "@boost//:thread",
        "@boost//:timer",
        "@boost//:type_erasure",
        "@boost//:wave",
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
# "@librdkafka//:kafka",
# "@jemalloc",
# "@apache_arrow//:arrow",

# "@org_gnu_gzip//:gzip",
