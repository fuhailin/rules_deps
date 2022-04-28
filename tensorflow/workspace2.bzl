"""TensorFlow workspace initialization. Consult the WORKSPACE on how to use it."""

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# Import third party config rules.
load("//tensorflow:version_check.bzl", "check_bazel_version_at_least")
load("//third_party/gpus:cuda_configure.bzl", "cuda_configure")
load("//third_party/gpus:rocm_configure.bzl", "rocm_configure")
load("//third_party/tensorrt:tensorrt_configure.bzl", "tensorrt_configure")
load("//third_party/nccl:nccl_configure.bzl", "nccl_configure")
load("//third_party/git:git_configure.bzl", "git_configure")
load("//third_party/py:python_configure.bzl", "python_configure")
load("//third_party/systemlibs:syslibs_configure.bzl", "syslibs_configure")
load("//tensorflow/tools/toolchains:cpus/arm/arm_compiler_configure.bzl", "arm_compiler_configure")
load("//tensorflow/tools/toolchains:embedded/arm-linux/arm_linux_toolchain_configure.bzl", "arm_linux_toolchain_configure")
load("//third_party:repo.bzl", "tf_http_archive", "tf_mirror_urls")
load("//third_party/clang_toolchain:cc_configure_clang.bzl", "cc_download_clang_toolchain")
load("//tensorflow/tools/def_file_filter:def_file_filter_configure.bzl", "def_file_filter_configure")
load("//third_party/llvm:setup.bzl", "llvm_setup")

# Import third party repository rules. See go/tfbr-thirdparty.
load("//third_party/FP16:workspace.bzl", FP16 = "repo")
load("//third_party/farmhash:workspace.bzl", farmhash = "repo")
load("//third_party/gemmlowp:workspace.bzl", gemmlowp = "repo")
load("//third_party/hexagon:workspace.bzl", hexagon_nn = "repo")
load("//third_party/highwayhash:workspace.bzl", highwayhash = "repo")
load("//third_party/hwloc:workspace.bzl", hwloc = "repo")
load("//third_party/icu:workspace.bzl", icu = "repo")
load("//third_party/jpeg:workspace.bzl", jpeg = "repo")
load("//third_party/libprotobuf_mutator:workspace.bzl", libprotobuf_mutator = "repo")
load("//third_party/nasm:workspace.bzl", nasm = "repo")
load("//third_party/pybind11_abseil:workspace.bzl", pybind11_abseil = "repo")
load("//third_party/opencl_headers:workspace.bzl", opencl_headers = "repo")
load("//third_party/kissfft:workspace.bzl", kissfft = "repo")
load("//third_party/pasta:workspace.bzl", pasta = "repo")
load("//third_party/psimd:workspace.bzl", psimd = "repo")
load("//third_party/ruy:workspace.bzl", ruy = "repo")
load("//third_party/sobol_data:workspace.bzl", sobol_data = "repo")
load("//third_party/vulkan_headers:workspace.bzl", vulkan_headers = "repo")
load("//third_party/tensorrt:workspace.bzl", tensorrt = "repo")

# Import external repository rules.
load("@bazel_tools//tools/build_defs/repo:java.bzl", "java_import_external")
load("@io_bazel_rules_closure//closure:defs.bzl", "filegroup_external")
load("@tf_runtime//:dependencies.bzl", "tfrt_dependencies")
load("//tensorflow/tools/toolchains/remote_config:configs.bzl", "initialize_rbe_configs")
load("//tensorflow/tools/toolchains/remote:configure.bzl", "remote_execution_configure")
load("//tensorflow/tools/toolchains/clang6:repo.bzl", "clang6_configure")
load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
load("@rules_foreign_cc//foreign_cc:repositories.bzl", "rules_foreign_cc_dependencies")

def _initialize_third_party():
    """ Load third party repositories.  See above load() statements. """
    FP16()
    farmhash()
    gemmlowp()
    hexagon_nn()
    highwayhash()
    hwloc()
    icu()
    jpeg()
    kissfft()
    libprotobuf_mutator()
    nasm()
    opencl_headers()
    pasta()
    psimd()
    pybind11_abseil()
    ruy()
    sobol_data()
    vulkan_headers()
    tensorrt()

# Toolchains & platforms required by Tensorflow to build.
def _tf_toolchains():
    native.register_execution_platforms("@local_execution_config_platform//:platform")
    native.register_toolchains("@local_execution_config_python//:py_toolchain")

    # Loads all external repos to configure RBE builds.
    initialize_rbe_configs()

    # Note that we check the minimum bazel version in WORKSPACE.
    clang6_configure(name = "local_config_clang6")
    cc_download_clang_toolchain(name = "local_config_download_clang")
    cuda_configure(name = "local_config_cuda")
    tensorrt_configure(name = "local_config_tensorrt")
    nccl_configure(name = "local_config_nccl")
    git_configure(name = "local_config_git")
    syslibs_configure(name = "local_config_syslibs")
    python_configure(name = "local_config_python")
    rocm_configure(name = "local_config_rocm")
    remote_execution_configure(name = "local_config_remote_execution")

    # For windows bazel build
    # TODO: Remove def file filter when TensorFlow can export symbols properly on Windows.
    def_file_filter_configure(name = "local_config_def_file_filter")

    # Point //external/local_config_arm_compiler to //external/arm_compiler
    arm_compiler_configure(
        name = "local_config_arm_compiler",
        build_file = "//tensorflow/tools/toolchains/cpus/arm:template.BUILD",
        remote_config_repo_arm = "../arm_compiler",
        remote_config_repo_aarch64 = "../aarch64_compiler",
    )

    # TFLite crossbuild toolchain for embeddeds Linux
    arm_linux_toolchain_configure(
        name = "local_config_embedded_arm",
        build_file = "//tensorflow/tools/toolchains/embedded/arm-linux:template.BUILD",
        aarch64_repo = "../aarch64_linux_toolchain",
        armhf_repo = "../armhf_linux_toolchain",
    )

# Define all external repositories required by TensorFlow
def _tf_repositories():
    """All external dependencies for TF builds."""

    # To update any of the dependencies bellow:
    # a) update URL and strip_prefix to the new git commit hash
    # b) get the sha256 hash of the commit by running:
    #    curl -L <url> | sha256sum
    # and update the sha256 with the result.

    # LINT.IfChange
    tf_http_archive(
        name = "XNNPACK",
        sha256 = "899d307ba5e356607e559f7e0e97257dafb134bae443bb4d98ea71989dbbadc9",
        strip_prefix = "XNNPACK-7ff11f770a1e803ab9d5c70c82457d496a93965a",
        urls = tf_mirror_urls("https://github.com/google/XNNPACK/archive/7ff11f770a1e803ab9d5c70c82457d496a93965a.zip"),
    )
    # LINT.ThenChange(//tensorflow/lite/tools/cmake/modules/xnnpack.cmake)

    tf_http_archive(
        name = "FXdiv",
        sha256 = "3d7b0e9c4c658a84376a1086126be02f9b7f753caa95e009d9ac38d11da444db",
        strip_prefix = "FXdiv-63058eff77e11aa15bf531df5dd34395ec3017c8",
        urls = tf_mirror_urls("https://github.com/Maratyszcza/FXdiv/archive/63058eff77e11aa15bf531df5dd34395ec3017c8.zip"),
    )

    tf_http_archive(
        name = "pthreadpool",
        sha256 = "b96413b10dd8edaa4f6c0a60c6cf5ef55eebeef78164d5d69294c8173457f0ec",
        strip_prefix = "pthreadpool-b8374f80e42010941bda6c85b0e3f1a1bd77a1e0",
        urls = tf_mirror_urls("https://github.com/Maratyszcza/pthreadpool/archive/b8374f80e42010941bda6c85b0e3f1a1bd77a1e0.zip"),
    )

    tf_http_archive(
        name = "cudnn_frontend_archive",
        build_file = "//third_party:cudnn_frontend.BUILD",
        patch_file = ["//third_party:cudnn_frontend_header_fix.patch"],
        sha256 = "fdf4234e9c9c481b3b3a80ad404bc278e6ecb761c5574beb4d3a2cde4a9002ad",
        strip_prefix = "cudnn-frontend-73210a930333eaf66b42b01693bce7b70719c354",
        urls = tf_mirror_urls("https://github.com/NVIDIA/cudnn-frontend/archive/73210a930333eaf66b42b01693bce7b70719c354.zip"),
    )

    tf_http_archive(
        name = "mkl_dnn",
        build_file = "//third_party/mkl_dnn:mkldnn.BUILD",
        sha256 = "a0211aeb5e7dad50b97fa5dffc1a2fe2fe732572d4164e1ee8750a2ede43fbec",
        strip_prefix = "oneDNN-0.21.3",
        urls = tf_mirror_urls("https://github.com/oneapi-src/oneDNN/archive/v0.21.3.tar.gz"),
    )

    tf_http_archive(
        name = "mkl_dnn_v1",
        build_file = "//third_party/mkl_dnn:mkldnn_v1.BUILD",
        sha256 = "f1c5a35c2c091e02417d7aa6ede83f863d35cf0ad91a132185952f5cca7b4887",
        strip_prefix = "oneDNN-2.5.1",
        urls = tf_mirror_urls("https://github.com/oneapi-src/oneDNN/archive/refs/tags/v2.5.1.tar.gz"),
    )

    tf_http_archive(
        name = "mkl_dnn_acl_compatible",
        build_file = "//third_party/mkl_dnn:mkldnn_acl.BUILD",
        sha256 = "d7a47caeb28d2c67dc8fa0d0f338b11fbf25b473a608f04cfed913aea88815a9",
        strip_prefix = "oneDNN-2.5",
        urls = tf_mirror_urls("https://github.com/oneapi-src/oneDNN/archive/v2.5.tar.gz"),
    )

    tf_http_archive(
        name = "compute_library",
        sha256 = "8322ed2e135999569082a95e7fbb2fa87786ffb1c67935b3ef71e00b53f2c887",
        strip_prefix = "ComputeLibrary-21.11",
        build_file = "//third_party/compute_library:BUILD",
        patch_file = ["//third_party/compute_library:compute_library.patch"],
        urls = tf_mirror_urls("https://github.com/ARM-software/ComputeLibrary/archive/v21.11.tar.gz"),
    )

    tf_http_archive(
        name = "arm_compiler",
        build_file = "//:arm_compiler.BUILD",
        sha256 = "b9e7d50ffd9996ed18900d041d362c99473b382c0ae049b2fce3290632d2656f",
        strip_prefix = "rpi-newer-crosstools-eb68350c5c8ec1663b7fe52c742ac4271e3217c5/x64-gcc-6.5.0/arm-rpi-linux-gnueabihf/",
        urls = tf_mirror_urls("https://github.com/rvagg/rpi-newer-crosstools/archive/eb68350c5c8ec1663b7fe52c742ac4271e3217c5.tar.gz"),
    )

    tf_http_archive(
        # This is the latest `aarch64-none-linux-gnu` compiler provided by ARM
        # See https://developer.arm.com/tools-and-software/open-source-software/developer-tools/gnu-toolchain/gnu-a/downloads
        # The archive contains GCC version 9.2.1
        name = "aarch64_compiler",
        build_file = "//:arm_compiler.BUILD",
        sha256 = "8dfe681531f0bd04fb9c53cf3c0a3368c616aa85d48938eebe2b516376e06a66",
        strip_prefix = "gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu",
        urls = tf_mirror_urls("https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz"),
    )

    tf_http_archive(
        name = "aarch64_linux_toolchain",
        build_file = "//tensorflow/tools/toolchains/embedded/arm-linux:aarch64-linux-toolchain.BUILD",
        sha256 = "8ce3e7688a47d8cd2d8e8323f147104ae1c8139520eca50ccf8a7fa933002731",
        strip_prefix = "gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu",
        urls = tf_mirror_urls("https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-aarch64-linux-gnu.tar.xz"),
    )

    tf_http_archive(
        name = "armhf_linux_toolchain",
        build_file = "//tensorflow/tools/toolchains/embedded/arm-linux:armhf-linux-toolchain.BUILD",
        sha256 = "d4f6480ecaa99e977e3833cc8a8e1263f9eecd1ce2d022bb548a24c4f32670f5",
        strip_prefix = "gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf",
        urls = tf_mirror_urls("https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf.tar.xz"),
    )

    tf_http_archive(
        name = "libxsmm_archive",
        build_file = "//third_party:libxsmm.BUILD",
        sha256 = "e491ccadebc5cdcd1fc08b5b4509a0aba4e2c096f53d7880062a66b82a0baf84",
        strip_prefix = "libxsmm-1.16.3",
        urls = tf_mirror_urls("https://github.com/hfp/libxsmm/archive/1.16.3.tar.gz"),
    )

    tf_http_archive(
        name = "com_googlesource_code_re2",
        sha256 = "d070e2ffc5476c496a6a872a6f246bfddce8e7797d6ba605a7c8d72866743bf9",
        strip_prefix = "re2-506cfa4bffd060c06ec338ce50ea3468daa6c814",
        system_build_file = "//third_party/systemlibs:re2.BUILD",
        urls = tf_mirror_urls("https://github.com/google/re2/archive/506cfa4bffd060c06ec338ce50ea3468daa6c814.tar.gz"),
    )

    tf_http_archive(
        name = "com_github_google_crc32c",
        sha256 = "6b3b1d861bb8307658b2407bc7a4c59e566855ef5368a60b35c893551e4788e9",
        build_file = "@com_github_googlecloudplatform_google_cloud_cpp//bazel:crc32c.BUILD",
        strip_prefix = "crc32c-1.0.6",
        urls = tf_mirror_urls("https://github.com/google/crc32c/archive/1.0.6.tar.gz"),
    )

    tf_http_archive(
        name = "com_github_googlecloudplatform_google_cloud_cpp",
        sha256 = "ff82045b9491f0d880fc8e5c83fd9542eafb156dcac9ff8c6209ced66ed2a7f0",
        strip_prefix = "google-cloud-cpp-1.17.1",
        repo_mapping = {
            "@com_github_curl_curl": "@curl",
            "@com_github_nlohmann_json": "@nlohmann_json_lib",
        },
        system_build_file = "//third_party/systemlibs:google_cloud_cpp.BUILD",
        system_link_files = {
            "//third_party/systemlibs:google_cloud_cpp.google.cloud.bigtable.BUILD": "google/cloud/bigtable/BUILD",
        },
        urls = tf_mirror_urls("https://github.com/googleapis/google-cloud-cpp/archive/v1.17.1.tar.gz"),
    )

    tf_http_archive(
        name = "com_github_googlecloudplatform_tensorflow_gcp_tools",
        sha256 = "5e9ebe17eaa2895eb7f77fefbf52deeda7c4b63f5a616916b823eb74f3a0c542",
        strip_prefix = "tensorflow-gcp-tools-2643d8caeba6ca2a6a0b46bb123953cb95b7e7d5",
        urls = tf_mirror_urls("https://github.com/GoogleCloudPlatform/tensorflow-gcp-tools/archive/2643d8caeba6ca2a6a0b46bb123953cb95b7e7d5.tar.gz"),
    )

    tf_http_archive(
        name = "com_google_googleapis",
        build_file = "//third_party/googleapis:googleapis.BUILD",
        sha256 = "7ebab01b06c555f4b6514453dc3e1667f810ef91d1d4d2d3aa29bb9fcb40a900",
        strip_prefix = "googleapis-541b1ded4abadcc38e8178680b0677f65594ea6f",
        urls = tf_mirror_urls("https://github.com/googleapis/googleapis/archive/541b1ded4abadcc38e8178680b0677f65594ea6f.zip"),
    )

    tf_http_archive(
        name = "png",
        build_file = "//third_party:png.BUILD",
        patch_file = ["//third_party:png_fix_rpi.patch"],
        sha256 = "ca74a0dace179a8422187671aee97dd3892b53e168627145271cad5b5ac81307",
        strip_prefix = "libpng-1.6.37",
        system_build_file = "//third_party/systemlibs:png.BUILD",
        urls = tf_mirror_urls("https://github.com/glennrp/libpng/archive/v1.6.37.tar.gz"),
    )

    tf_http_archive(
        name = "org_sqlite",
        build_file = "//third_party:sqlite.BUILD",
        sha256 = "b65d2b72ce1296bb4314bbca1bede332a0f789b08a17e3e6e2e7ce6e870cde92",
        strip_prefix = "sqlite-amalgamation-3370100",
        system_build_file = "//third_party/systemlibs:sqlite.BUILD",
        urls = tf_mirror_urls("https://www.sqlite.org/2021/sqlite-amalgamation-3370100.zip"),
    )

    tf_http_archive(
        name = "gif",
        build_file = "//third_party:gif.BUILD",
        patch_file = ["//third_party:gif_fix_strtok_r.patch"],
        sha256 = "31da5562f44c5f15d63340a09a4fd62b48c45620cd302f77a6d9acf0077879bd",
        strip_prefix = "giflib-5.2.1",
        system_build_file = "//third_party/systemlibs:gif.BUILD",
        urls = tf_mirror_urls("https://pilotfiber.dl.sourceforge.net/project/giflib/giflib-5.2.1.tar.gz"),
    )

    tf_http_archive(
        name = "six_archive",
        build_file = "//third_party:six.BUILD",
        sha256 = "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259",
        strip_prefix = "six-1.15.0",
        system_build_file = "//third_party/systemlibs:six.BUILD",
        urls = tf_mirror_urls("https://pypi.python.org/packages/source/s/six/six-1.15.0.tar.gz"),
    )

    tf_http_archive(
        name = "astor_archive",
        build_file = "//third_party:astor.BUILD",
        sha256 = "95c30d87a6c2cf89aa628b87398466840f0ad8652f88eb173125a6df8533fb8d",
        strip_prefix = "astor-0.7.1",
        system_build_file = "//third_party/systemlibs:astor.BUILD",
        urls = tf_mirror_urls("https://pypi.python.org/packages/99/80/f9482277c919d28bebd85813c0a70117214149a96b08981b72b63240b84c/astor-0.7.1.tar.gz"),
    )

    tf_http_archive(
        name = "astunparse_archive",
        build_file = "//third_party:astunparse.BUILD",
        sha256 = "5ad93a8456f0d084c3456d059fd9a92cce667963232cbf763eac3bc5b7940872",
        strip_prefix = "astunparse-1.6.3/lib",
        system_build_file = "//third_party/systemlibs:astunparse.BUILD",
        urls = tf_mirror_urls("https://files.pythonhosted.org/packages/f3/af/4182184d3c338792894f34a62672919db7ca008c89abee9b564dd34d8029/astunparse-1.6.3.tar.gz"),
    )

    filegroup_external(
        name = "astunparse_license",
        licenses = ["notice"],  # PSFL
        sha256_urls = {
            "92fc0e4f4fa9460558eedf3412b988d433a2dcbb3a9c45402a145a4fab8a6ac6": tf_mirror_urls("https://raw.githubusercontent.com/simonpercivall/astunparse/v1.6.2/LICENSE"),
        },
    )

    tf_http_archive(
        name = "functools32_archive",
        build_file = "//third_party:functools32.BUILD",
        sha256 = "f6253dfbe0538ad2e387bd8fdfd9293c925d63553f5813c4e587745416501e6d",
        strip_prefix = "functools32-3.2.3-2",
        system_build_file = "//third_party/systemlibs:functools32.BUILD",
        urls = tf_mirror_urls("https://pypi.python.org/packages/c5/60/6ac26ad05857c601308d8fb9e87fa36d0ebf889423f47c3502ef034365db/functools32-3.2.3-2.tar.gz"),
    )

    tf_http_archive(
        name = "gast_archive",
        build_file = "//third_party:gast.BUILD",
        sha256 = "40feb7b8b8434785585ab224d1568b857edb18297e5a3047f1ba012bc83b42c1",
        strip_prefix = "gast-0.4.0",
        system_build_file = "//third_party/systemlibs:gast.BUILD",
        urls = tf_mirror_urls("https://files.pythonhosted.org/packages/83/4a/07c7e59cef23fb147454663c3271c21da68ba2ab141427c20548ae5a8a4d/gast-0.4.0.tar.gz"),
    )

    tf_http_archive(
        name = "termcolor_archive",
        build_file = "//third_party:termcolor.BUILD",
        sha256 = "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b",
        strip_prefix = "termcolor-1.1.0",
        system_build_file = "//third_party/systemlibs:termcolor.BUILD",
        urls = tf_mirror_urls("https://pypi.python.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981/termcolor-1.1.0.tar.gz"),
    )

    tf_http_archive(
        name = "typing_extensions_archive",
        build_file = "//third_party:typing_extensions.BUILD",
        sha256 = "79ee589a3caca649a9bfd2a8de4709837400dfa00b6cc81962a1e6a1815969ae",
        strip_prefix = "typing_extensions-3.7.4.2/src_py3",
        system_build_file = "//third_party/systemlibs:typing_extensions.BUILD",
        urls = tf_mirror_urls("https://files.pythonhosted.org/packages/6a/28/d32852f2af6b5ead85d396249d5bdf450833f3a69896d76eb480d9c5e406/typing_extensions-3.7.4.2.tar.gz"),
    )

    filegroup_external(
        name = "typing_extensions_license",
        licenses = ["notice"],  # PSFL
        sha256_urls = {
            "ff17ce94e102024deb68773eb1cc74ca76da4e658f373531f0ac22d68a6bb1ad": tf_mirror_urls("https://raw.githubusercontent.com/python/typing/master/typing_extensions/LICENSE"),
        },
    )

    tf_http_archive(
        name = "opt_einsum_archive",
        build_file = "//third_party:opt_einsum.BUILD",
        sha256 = "d3d464b4da7ef09e444c30e4003a27def37f85ff10ff2671e5f7d7813adac35b",
        strip_prefix = "opt_einsum-2.3.2",
        system_build_file = "//third_party/systemlibs:opt_einsum.BUILD",
        urls = tf_mirror_urls("https://pypi.python.org/packages/f6/d6/44792ec668bcda7d91913c75237314e688f70415ab2acd7172c845f0b24f/opt_einsum-2.3.2.tar.gz"),
    )

    tf_http_archive(
        name = "dill_archive",
        build_file = "//third_party:dill.BUILD",
        system_build_file = "//third_party/systemlibs:dill.BUILD",
        urls = tf_mirror_urls("https://files.pythonhosted.org/packages/e2/96/518a8ea959a734b70d2e95fef98bcbfdc7adad1c1e5f5dd9148c835205a5/dill-0.3.2.zip"),
        sha256 = "6e12da0d8e49c220e8d6e97ee8882002e624f1160289ce85ec2cc0a5246b3a2e",
        strip_prefix = "dill-0.3.2",
    )

    tf_http_archive(
        name = "tblib_archive",
        build_file = "//third_party:tblib.BUILD",
        system_build_file = "//third_party/systemlibs:tblib.BUILD",
        urls = tf_mirror_urls("https://files.pythonhosted.org/packages/d3/41/901ef2e81d7b1e834b9870d416cb09479e175a2be1c4aa1a9dcd0a555293/tblib-1.7.0.tar.gz"),
        sha256 = "059bd77306ea7b419d4f76016aef6d7027cc8a0785579b5aad198803435f882c",
        strip_prefix = "tblib-1.7.0",
    )

    filegroup_external(
        name = "org_python_license",
        licenses = ["notice"],  # Python 2.0
        sha256_urls = {
            "e76cacdf0bdd265ff074ccca03671c33126f597f39d0ed97bc3e5673d9170cf6": tf_mirror_urls("https://docs.python.org/2.7/_sources/license.rst.txt"),
        },
    )

    PROTOBUF_VERSION = "3.19.4"
    git_repository(
        name = "com_google_protobuf",
        remote = "https://github.com/protocolbuffers/protobuf",
        tag = "v" + PROTOBUF_VERSION,
    )

    http_archive(
        name = "com_google_protobuf_javalite",
        strip_prefix = "protobuf-" + PROTOBUF_VERSION,
        urls = [
            "https://github.com/protocolbuffers/protobuf/archive/v{}.zip".format(PROTOBUF_VERSION),
        ],
    )

    tf_http_archive(
        name = "nsync",
        patch_file = ["//third_party:nsync.patch"],
        sha256 = "caf32e6b3d478b78cff6c2ba009c3400f8251f646804bcb65465666a9cea93c4",
        strip_prefix = "nsync-1.22.0",
        system_build_file = "//third_party/systemlibs:nsync.BUILD",
        urls = tf_mirror_urls("https://github.com/google/nsync/archive/1.22.0.tar.gz"),
    )

    http_archive(
        name = "com_google_googletest",
        urls = ["https://github.com/google/googletest/archive/609281088cfefc76f9d0ce82e1ff6c30cc3591e5.zip"],
        strip_prefix = "googletest-609281088cfefc76f9d0ce82e1ff6c30cc3591e5",
    )

    git_repository(
        name = "com_github_gflags_gflags",
        remote = "https://github.com/gflags/gflags.git",
        tag = "v2.2.2",
    )

    http_archive(
        name = "com_github_google_glog",
        sha256 = "21bc744fb7f2fa701ee8db339ded7dce4f975d0d55837a97be7d46e8382dea5a",
        strip_prefix = "glog-0.5.0",
        urls = ["https://github.com/google/glog/archive/v0.5.0.zip"],
    )

    git_repository(
        name = "com_github_grpc_grpc",
        remote = "https://github.com/grpc/grpc",
        tag = "v1.45.0",
    )

    tf_http_archive(
        name = "linenoise",
        build_file = "//third_party:linenoise.BUILD",
        sha256 = "7f51f45887a3d31b4ce4fa5965210a5e64637ceac12720cfce7954d6a2e812f7",
        strip_prefix = "linenoise-c894b9e59f02203dbe4e2be657572cf88c4230c3",
        urls = tf_mirror_urls("https://github.com/antirez/linenoise/archive/c894b9e59f02203dbe4e2be657572cf88c4230c3.tar.gz"),
    )

    llvm_setup(name = "llvm-project")

    # Intel openMP that is part of LLVM sources.
    tf_http_archive(
        name = "llvm_openmp",
        build_file = "//third_party/llvm_openmp:BUILD",
        sha256 = "d19f728c8e04fb1e94566c8d76aef50ec926cd2f95ef3bf1e0a5de4909b28b44",
        strip_prefix = "openmp-10.0.1.src",
        urls = tf_mirror_urls("https://github.com/llvm/llvm-project/releases/download/llvmorg-10.0.1/openmp-10.0.1.src.tar.xz"),
    )

    tf_http_archive(
        name = "lmdb",
        build_file = "//third_party:lmdb.BUILD",
        sha256 = "22054926b426c66d8f2bc22071365df6e35f3aacf19ad943bc6167d4cae3bebb",
        strip_prefix = "lmdb-LMDB_0.9.29/libraries/liblmdb",
        system_build_file = "//third_party/systemlibs:lmdb.BUILD",
        urls = tf_mirror_urls("https://github.com/LMDB/lmdb/archive/refs/tags/LMDB_0.9.29.tar.gz"),
    )

    tf_http_archive(
        name = "jsoncpp_git",
        sha256 = "f409856e5920c18d0c2fb85276e24ee607d2a09b5e7d5f0a371368903c275da2",
        strip_prefix = "jsoncpp-1.9.5",
        system_build_file = "//third_party/systemlibs:jsoncpp.BUILD",
        urls = tf_mirror_urls("https://github.com/open-source-parsers/jsoncpp/archive/1.9.5.tar.gz"),
    )

    tf_http_archive(
        name = "boringssl",
        sha256 = "a9c3b03657d507975a32732f04563132b4553c20747cec6dc04de475c8bdf29f",
        strip_prefix = "boringssl-80ca9f9f6ece29ab132cce4cf807a9465a18cfac",
        system_build_file = "//third_party/systemlibs:boringssl.BUILD",
        urls = tf_mirror_urls("https://github.com/google/boringssl/archive/80ca9f9f6ece29ab132cce4cf807a9465a18cfac.tar.gz"),
    )

    # LINT.IfChange
    tf_http_archive(
        name = "fft2d",
        build_file = "//third_party/fft2d:fft2d.BUILD",
        sha256 = "5f4dabc2ae21e1f537425d58a49cdca1c49ea11db0d6271e2a4b27e9697548eb",
        strip_prefix = "OouraFFT-1.0",
        urls = tf_mirror_urls("https://github.com/petewarden/OouraFFT/archive/v1.0.tar.gz"),
    )
    # LINT.ThenChange(//tensorflow/lite/tools/cmake/modules/fft2d.cmake)

    tf_http_archive(
        name = "nccl_archive",
        build_file = "//third_party:nccl/archive.BUILD",
        patch_file = ["//third_party/nccl:archive.patch"],
        sha256 = "3ae89ddb2956fff081e406a94ff54ae5e52359f5d645ce977c7eba09b3b782e6",
        strip_prefix = "nccl-2.8.3-1",
        urls = tf_mirror_urls("https://github.com/nvidia/nccl/archive/v2.8.3-1.tar.gz"),
    )

    java_import_external(
        name = "junit",
        jar_sha256 = "59721f0805e223d84b90677887d9ff567dc534d7c502ca903c0c2b17f05c116a",
        jar_urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/repo1.maven.org/maven2/junit/junit/4.12/junit-4.12.jar",
            "https://repo1.maven.org/maven2/junit/junit/4.12/junit-4.12.jar",
            "https://maven.ibiblio.org/maven2/junit/junit/4.12/junit-4.12.jar",
        ],
        licenses = ["reciprocal"],  # Common Public License Version 1.0
        testonly_ = True,
        deps = ["@org_hamcrest_core"],
    )

    java_import_external(
        name = "org_hamcrest_core",
        jar_sha256 = "66fdef91e9739348df7a096aa384a5685f4e875584cce89386a7a47251c4d8e9",
        jar_urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar",
            "https://repo1.maven.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar",
            "https://maven.ibiblio.org/maven2/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar",
        ],
        licenses = ["notice"],  # New BSD License
        testonly_ = True,
    )

    java_import_external(
        name = "com_google_testing_compile",
        jar_sha256 = "edc180fdcd9f740240da1a7a45673f46f59c5578d8cd3fbc912161f74b5aebb8",
        jar_urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/repo1.maven.org/maven2/com/google/testing/compile/compile-testing/0.11/compile-testing-0.11.jar",
            "https://repo1.maven.org/maven2/com/google/testing/compile/compile-testing/0.11/compile-testing-0.11.jar",
        ],
        licenses = ["notice"],  # New BSD License
        testonly_ = True,
        deps = ["@com_google_guava", "@com_google_truth"],
    )

    java_import_external(
        name = "com_google_truth",
        jar_sha256 = "032eddc69652b0a1f8d458f999b4a9534965c646b8b5de0eba48ee69407051df",
        jar_urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/repo1.maven.org/maven2/com/google/truth/truth/0.32/truth-0.32.jar",
            "https://repo1.maven.org/maven2/com/google/truth/truth/0.32/truth-0.32.jar",
        ],
        licenses = ["notice"],  # Apache 2.0
        testonly_ = True,
        deps = ["@com_google_guava"],
    )

    java_import_external(
        name = "org_checkerframework_qual",
        jar_sha256 = "d261fde25d590f6b69db7721d469ac1b0a19a17ccaaaa751c31f0d8b8260b894",
        jar_urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/repo1.maven.org/maven2/org/checkerframework/checker-qual/2.10.0/checker-qual-2.10.0.jar",
            "https://repo1.maven.org/maven2/org/checkerframework/checker-qual/2.10.0/checker-qual-2.10.0.jar",
        ],
        licenses = ["notice"],  # Apache 2.0
    )

    java_import_external(
        name = "com_squareup_javapoet",
        jar_sha256 = "5bb5abdfe4366c15c0da3332c57d484e238bd48260d6f9d6acf2b08fdde1efea",
        jar_urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/repo1.maven.org/maven2/com/squareup/javapoet/1.9.0/javapoet-1.9.0.jar",
            "https://repo1.maven.org/maven2/com/squareup/javapoet/1.9.0/javapoet-1.9.0.jar",
        ],
        licenses = ["notice"],  # Apache 2.0
    )

    tf_http_archive(
        name = "com_google_pprof",
        build_file = "//third_party:pprof.BUILD",
        sha256 = "e0928ca4aa10ea1e0551e2d7ce4d1d7ea2d84b2abbdef082b0da84268791d0c4",
        strip_prefix = "pprof-c0fb62ec88c411cc91194465e54db2632845b650",
        urls = tf_mirror_urls("https://github.com/google/pprof/archive/c0fb62ec88c411cc91194465e54db2632845b650.tar.gz"),
    )

    # The CUDA 11 toolkit ships with CUB.  We should be able to delete this rule
    # once TF drops support for CUDA 10.
    tf_http_archive(
        name = "cub_archive",
        build_file = "//third_party:cub.BUILD",
        sha256 = "162514b3cc264ac89d91898b58450190b8192e2af1142cf8ccac2d59aa160dda",
        strip_prefix = "cub-1.9.9",
        urls = tf_mirror_urls("https://github.com/NVlabs/cub/archive/1.9.9.zip"),
    )

    tf_http_archive(
        name = "cython",
        build_file = "//third_party:cython.BUILD",
        sha256 = "e2e38e1f0572ca54d6085df3dec8b607d20e81515fb80215aed19c81e8fe2079",
        strip_prefix = "cython-0.29.21",
        system_build_file = "//third_party/systemlibs:cython.BUILD",
        urls = tf_mirror_urls("https://github.com/cython/cython/archive/0.29.21.tar.gz"),
    )

    # LINT.IfChange
    tf_http_archive(
        name = "arm_neon_2_x86_sse",
        build_file = "//third_party:arm_neon_2_x86_sse.BUILD",
        sha256 = "213733991310b904b11b053ac224fee2d4e0179e46b52fe7f8735b8831e04dcc",
        strip_prefix = "ARM_NEON_2_x86_SSE-1200fe90bb174a6224a525ee60148671a786a71f",
        urls = tf_mirror_urls("https://github.com/intel/ARM_NEON_2_x86_SSE/archive/1200fe90bb174a6224a525ee60148671a786a71f.tar.gz"),
    )
    # LINT.ThenChange(//tensorflow/lite/tools/cmake/modules/neon2sse.cmake)

    http_archive(
        name = "com_github_google_double_conversion",
        urls = ["https://github.com/google/double-conversion/archive/v3.1.5.tar.gz"],
        build_file = Label("//third_party:double-conversion.BUILD"),
        sha256 = "a63ecb93182134ba4293fd5f22d6e08ca417caafa244afaa751cbfddf6415b13",
        strip_prefix = "double-conversion-3.1.5",
    )

    tf_http_archive(
        name = "tflite_mobilenet_float",
        build_file = "//third_party:tflite_mobilenet_float.BUILD",
        sha256 = "2fadeabb9968ec6833bee903900dda6e61b3947200535874ce2fe42a8493abc0",
        urls = [
            "https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_2018_08_02/mobilenet_v1_1.0_224.tgz",
            "https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_2018_08_02/mobilenet_v1_1.0_224.tgz",
        ],
    )

    tf_http_archive(
        name = "tflite_mobilenet_quant",
        build_file = "//third_party:tflite_mobilenet_quant.BUILD",
        sha256 = "d32432d28673a936b2d6281ab0600c71cf7226dfe4cdcef3012555f691744166",
        urls = [
            "https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_2018_08_02/mobilenet_v1_1.0_224_quant.tgz",
            "https://storage.googleapis.com/download.tensorflow.org/models/mobilenet_v1_2018_08_02/mobilenet_v1_1.0_224_quant.tgz",
        ],
    )

    tf_http_archive(
        name = "tflite_mobilenet_ssd",
        build_file = str(Label("//third_party:tflite_mobilenet.BUILD")),
        sha256 = "767057f2837a46d97882734b03428e8dd640b93236052b312b2f0e45613c1cf0",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/storage.googleapis.com/download.tensorflow.org/models/tflite/mobilenet_ssd_tflite_v1.zip",
            "https://storage.googleapis.com/download.tensorflow.org/models/tflite/mobilenet_ssd_tflite_v1.zip",
        ],
    )

    tf_http_archive(
        name = "tflite_mobilenet_ssd_quant",
        build_file = str(Label("//third_party:tflite_mobilenet.BUILD")),
        sha256 = "a809cd290b4d6a2e8a9d5dad076e0bd695b8091974e0eed1052b480b2f21b6dc",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_0.75_quant_2018_06_29.zip",
            "https://storage.googleapis.com/download.tensorflow.org/models/tflite/coco_ssd_mobilenet_v1_0.75_quant_2018_06_29.zip",
        ],
    )

    tf_http_archive(
        name = "tflite_mobilenet_ssd_quant_protobuf",
        build_file = str(Label("//third_party:tflite_mobilenet.BUILD")),
        sha256 = "09280972c5777f1aa775ef67cb4ac5d5ed21970acd8535aeca62450ef14f0d79",
        strip_prefix = "ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/storage.googleapis.com/download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz",
            "https://storage.googleapis.com/download.tensorflow.org/models/object_detection/ssd_mobilenet_v1_quantized_300x300_coco14_sync_2018_07_18.tar.gz",
        ],
    )

    tf_http_archive(
        name = "tflite_conv_actions_frozen",
        build_file = str(Label("//third_party:tflite_mobilenet.BUILD")),
        sha256 = "d947b38cba389b5e2d0bfc3ea6cc49c784e187b41a071387b3742d1acac7691e",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/storage.googleapis.com/download.tensorflow.org/models/tflite/conv_actions_tflite.zip",
            "https://storage.googleapis.com/download.tensorflow.org/models/tflite/conv_actions_tflite.zip",
        ],
    )

    tf_http_archive(
        name = "tflite_ovic_testdata",
        build_file = "//third_party:tflite_ovic_testdata.BUILD",
        sha256 = "033c941b7829b05ca55a124a26a6a0581b1ececc154a2153cafcfdb54f80dca2",
        strip_prefix = "ovic",
        urls = [
            "https://storage.googleapis.com/mirror.tensorflow.org/storage.googleapis.com/download.tensorflow.org/data/ovic_2019_04_30.zip",
            "https://storage.googleapis.com/download.tensorflow.org/data/ovic_2019_04_30.zip",
        ],
    )

    http_archive(
        name = "rules_python",
        sha256 = "9fcf91dbcc31fde6d1edb15f117246d912c33c36f44cf681976bd886538deba6",
        strip_prefix = "rules_python-0.8.0",
        url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.0.tar.gz",
    )

    tf_http_archive(
        name = "build_bazel_rules_android",
        sha256 = "cd06d15dd8bb59926e4d65f9003bfc20f9da4b2519985c27e190cddc8b7a7806",
        strip_prefix = "rules_android-0.1.1",
        urls = tf_mirror_urls("https://github.com/bazelbuild/rules_android/archive/v0.1.1.zip"),
    )

    # Apple and Swift rules.
    # https://github.com/bazelbuild/rules_apple/releases
    tf_http_archive(
        name = "build_bazel_rules_apple",
        sha256 = "a5f00fd89eff67291f6cd3efdc8fad30f4727e6ebb90718f3f05bbf3c3dd5ed7",
        urls = tf_mirror_urls("https://github.com/bazelbuild/rules_apple/releases/download/0.33.0/rules_apple.0.33.0.tar.gz"),
    )

    # https://github.com/bazelbuild/rules_swift/releases
    tf_http_archive(
        name = "build_bazel_rules_swift",
        sha256 = "8a49da750560b185804a4bc95c82d3f9cc4c2caf788960b0e21945759155fdd9",
        urls = tf_mirror_urls("https://github.com/bazelbuild/rules_swift/releases/download/0.25.0/rules_swift.0.25.0.tar.gz"),
    )

    # https://github.com/bazelbuild/apple_support/releases
    tf_http_archive(
        name = "build_bazel_apple_support",
        sha256 = "c604b75865c07f45828c7fffd5fdbff81415a9e84a68f71a9c1d8e3b2694e547",
        urls = tf_mirror_urls("https://github.com/bazelbuild/apple_support/releases/download/0.12.1/apple_support.0.12.1.tar.gz"),
    )

    # https://github.com/apple/swift-protobuf/releases
    tf_http_archive(
        name = "com_github_apple_swift_swift_protobuf",
        strip_prefix = "swift-protobuf-1.18.0/",
        sha256 = "6b96d07bfbfa1334909eeb1430c69a93af71c961695b0a5f3536d087a58d8e41",
        urls = tf_mirror_urls("https://github.com/apple/swift-protobuf/archive/1.18.0.zip"),
    )

    # https://github.com/google/xctestrunner/releases
    tf_http_archive(
        name = "xctestrunner",
        strip_prefix = "xctestrunner-0.2.15",
        sha256 = "b789cf18037c8c28d17365f14925f83b93b1f7dabcabb80333ae4331cf0bcb2f",
        urls = tf_mirror_urls("https://github.com/google/xctestrunner/archive/refs/tags/0.2.15.tar.gz"),
    )

    tf_http_archive(
        name = "nlohmann_json_lib",
        build_file = "//third_party:nlohmann_json.BUILD",
        sha256 = "d51a3a8d3efbb1139d7608e28782ea9efea7e7933157e8ff8184901efd8ee760",
        strip_prefix = "json-3.7.0",
        urls = tf_mirror_urls("https://github.com/nlohmann/json/archive/v3.7.0.tar.gz"),
    )

    tf_http_archive(
        name = "pybind11",
        urls = tf_mirror_urls("https://github.com/pybind/pybind11/archive/v2.9.0.tar.gz"),
        sha256 = "057fb68dafd972bc13afb855f3b0d8cf0fa1a78ef053e815d9af79be7ff567cb",
        strip_prefix = "pybind11-2.9.0",
        build_file = "//third_party:pybind11.BUILD",
        system_build_file = "//third_party/systemlibs:pybind11.BUILD",
    )

    tf_http_archive(
        name = "wrapt",
        build_file = "//third_party:wrapt.BUILD",
        sha256 = "8a6fb40e8f8b6a66b4ba81a4044c68e6a7b1782f21cfabc06fb765332b4c3e51",
        strip_prefix = "wrapt-1.11.1/src/wrapt",
        system_build_file = "//third_party/systemlibs:wrapt.BUILD",
        urls = tf_mirror_urls("https://github.com/GrahamDumpleton/wrapt/archive/1.11.1.tar.gz"),
    )

    tf_http_archive(
        name = "coremltools",
        sha256 = "0d594a714e8a5fd5bd740ad112ef59155c0482e25fdc8f8efa5758f90abdcf1e",
        strip_prefix = "coremltools-3.3",
        build_file = "//third_party:coremltools.BUILD",
        urls = tf_mirror_urls("https://github.com/apple/coremltools/archive/3.3.zip"),
    )

    tf_http_archive(
        name = "boost",
        sha256 = "7bd7ddceec1a1dfdcbdb3e609b60d01739c38390a5f956385a12f3122049f0ca",
        strip_prefix = "boost_1_76_0",
        build_file = "//third_party:boost.BUILD",
        urls = tf_mirror_urls("https://boostorg.jfrog.io/artifactory/main/release/1.76.0/source/boost_1_76_0.tar.gz"),
    )

    FOLLY_VERSION = "2022.01.24.00"
    http_archive(
        name = "com_github_facebook_folly",
        build_file = Label("//third_party/folly:folly.BUILD"),
        urls = [
            "https://github.com/facebook/folly/archive/refs/tags/v{tag}.tar.gz".format(tag = FOLLY_VERSION),
        ],
        # sha256 = "369d17a6603c1dc53db006bd5d613461b76db089bd90a85a713565c263497082",
        strip_prefix = "folly-" + FOLLY_VERSION,
    )

    http_archive(
        name = "com_github_fmtlib_fmt",
        strip_prefix = "fmt-8.0.1",
        sha256 = "b06ca3130158c625848f3fb7418f235155a4d389b2abc3a6245fb01cb0eb1e01",
        build_file = Label("//third_party:fmt.BUILD"),
        urls = ["https://github.com/fmtlib/fmt/archive/refs/tags/8.0.1.tar.gz"],
    )

    http_archive(
        name = "libssh2",
        sha256 = "d5fb8bd563305fd1074dda90bd053fb2d29fc4bce048d182f96eaa466dfadafd",
        strip_prefix = "libssh2-1.9.0",
        build_file = Label("//third_party:libssh2.BUILD"),
        urls = [
            "https://github.com/libssh2/libssh2/releases/download/libssh2-1.9.0/libssh2-1.9.0.tar.gz",
        ],
    )

    http_archive(
        name = "libgit2",
        sha256 = "ad73f845965cfd528e70f654e428073121a3fa0dc23caac81a1b1300277d4dba",
        strip_prefix = "libgit2-1.1.0",
        build_file = Label("//third_party:libgit2.BUILD"),
        urls = ["https://github.com/libgit2/libgit2/releases/download/v1.1.0/libgit2-1.1.0.tar.gz"],
    )

    http_archive(
        name = "com_github_jedisct1_libsodium",
        # sha256 = "ad73f845965cfd528e70f654e428073121a3fa0dc23caac81a1b1300277d4dba",
        strip_prefix = "libsodium-stable",
        build_file = Label("//third_party:libsodium.BUILD"),
        urls = ["https://download.libsodium.org/libsodium/releases/libsodium-1.0.18-stable.tar.gz"],
    )

    http_archive(
        name = "openssl",
        build_file = Label("//third_party/openssl:openssl.BUILD"),
        sha256 = "892a0875b9872acd04a9fde79b1f943075d5ea162415de3047c327df33fbaee5",
        strip_prefix = "openssl-1.1.1k",
        urls = [
            "https://mirror.bazel.build/www.openssl.org/source/openssl-1.1.1k.tar.gz",
            "https://www.openssl.org/source/openssl-1.1.1k.tar.gz",
            "https://github.com/openssl/openssl/archive/OpenSSL_1_1_1k.tar.gz",
        ],
    )

    http_archive(
        name = "nasm",
        build_file = Label("//third_party/openssl:nasm.BUILD"),
        sha256 = "f5c93c146f52b4f1664fa3ce6579f961a910e869ab0dae431bd871bdd2584ef2",
        strip_prefix = "nasm-2.15.05",
        urls = [
            "https://mirror.bazel.build/www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/nasm-2.15.05-win64.zip",
            "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/win64/nasm-2.15.05-win64.zip",
        ],
    )

    http_archive(
        name = "perl",
        build_file = Label("//third_party/openssl:perl.BUILD"),
        sha256 = "aeb973da474f14210d3e1a1f942dcf779e2ae7e71e4c535e6c53ebabe632cc98",
        urls = [
            "https://mirror.bazel.build/strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit.zip",
            "https://strawberryperl.com/download/5.32.1.1/strawberry-perl-5.32.1.1-64bit.zip",
        ],
    )

    http_archive(
        name = "hiredis",
        urls = [
            "https://github.com/redis/hiredis/archive/{}.tar.gz".format("dfa33e60b07c13328133a16065d88d171a2a61d4"),
        ],
        strip_prefix = "hiredis-" + "dfa33e60b07c13328133a16065d88d171a2a61d4",
        build_file = Label("//third_party/db:hiredis.BUILD"),
    )

    http_archive(
        name = "com_github_google_leveldb",
        urls = [
            "https://github.com/google/leveldb/archive/refs/tags/{}.tar.gz".format("1.23"),
        ],
        strip_prefix = "leveldb-" + "1.23",
        build_file = Label("//third_party/db:leveldb.BUILD"),
    )

    http_archive(
        name = "redis-plus-plus",
        urls = [
            "https://github.com/sewenew/redis-plus-plus/archive/refs/tags/{}.tar.gz".format("1.3.1"),
        ],
        strip_prefix = "redis-plus-plus-" + "1.3.1",
        build_file = Label("//third_party/db:redispp.BUILD"),
    )

    ROCKSDB_VERSION = "7.0.2"
    # ROCKSDB_SHA256 = "d7b994e1eb4dff9dfefcd51a63f86630282e1927fc42a300b93c573c853aa5d0"

    http_archive(
        name = "com_github_facebook_rocksdb",
        build_file = Label("//third_party/db:rocksdb.BUILD"),
        # sha256 = ROCKSDB_SHA256,
        strip_prefix = "rocksdb-{version}".format(version = ROCKSDB_VERSION),
        url = "https://github.com/facebook/rocksdb/archive/v{version}.tar.gz".format(version = ROCKSDB_VERSION),
    )

    http_archive(
        name = "com_github_bytedance_terarkdb",
        urls = [
            "https://github.com/bytedance/terarkdb/archive/refs/tags/v{}.tar.gz".format("1.3.6"),
        ],
        strip_prefix = "terarkdb-" + "1.3.6",
        build_file = Label("//third_party/db:terarkdb.BUILD"),
    )

    http_archive(
        name = "zeromq",
        sha256 = "805e3feab885c027edad3d09c4ac1a7e9bba9a05eac98f36127520e7af875010",
        strip_prefix = "libzmq-4.3.4",
        build_file = Label("//third_party:zeromq.BUILD"),
        urls = ["https://github.com/zeromq/libzmq/archive/v4.3.4.zip"],
    )

    http_archive(
        name = "com_github_jupp0r_prometheus_cpp",
        urls = [
            "https://github.com/jupp0r/prometheus-cpp/archive/v1.0.0.zip",
        ],
        strip_prefix = "prometheus-cpp-1.0.0",
        sha256 = "0a07b8dfc388d5da81fc02e356e6c78a896544c96cc40e8cca41e180a814e16c",
    )

    http_archive(
        name = "librdkafka",
        urls = [
            "https://github.com/edenhill/librdkafka/archive/refs/tags/v{}.tar.gz".format("1.8.2"),
        ],
        strip_prefix = "librdkafka-1.8.2",
        build_file = Label("//third_party:kafka.BUILD"),
    )

    http_archive(
        name = "cppunit",
        urls = [
            "https://github.com/freedesktop/libreoffice-cppunit/archive/{}.tar.gz".format("d7049a6dd98ef12f0949f3ccfbc8ff4dbd63df2e"),
        ],
        strip_prefix = "libreoffice-cppunit-d7049a6dd98ef12f0949f3ccfbc8ff4dbd63df2e",
        build_file = Label("//third_party:cppunit.BUILD"),
    )

    http_archive(
        name = "spdlog",
        urls = [
            "https://github.com/gabime/spdlog/archive/v{}.tar.gz".format("1.9.2"),
        ],
        strip_prefix = "spdlog-1.9.2",
        build_file = Label("//third_party:spdlog.BUILD"),
    )

    new_git_repository(
        name = "com_github_apache_thrift",
        remote = "https://github.com/apache/thrift",
        branch = "master",
        build_file = Label("//third_party/thrift:thrift.BUILD"),
    )

    FBTHRIFT_VERSION = "2022.01.24.00"
    http_archive(
        name = "com_github_facebook_fbthrift",
        build_file = Label("//third_party/fbthrift:fbthrift.BUILD"),
        # sha256 = "0fc6cc1673209f4557e081597b2311f6c9f153840c4e55ac61a669e10207e2ee",
        strip_prefix = "fbthrift-" + FBTHRIFT_VERSION,
        url = "https://github.com/facebook/fbthrift/archive/v{}.tar.gz".format(FBTHRIFT_VERSION),
    )

    http_archive(
        name = "com_github_tencent_rapidjson",
        urls = [
            "https://github.com/Tencent/rapidjson/archive/{}.tar.gz".format("00dbcf2c6e03c47d6c399338b6de060c71356464"),
        ],
        strip_prefix = "rapidjson-" + "00dbcf2c6e03c47d6c399338b6de060c71356464",
        build_file = Label("//third_party:rapidjson.BUILD"),
        sha256 = "b4339b8118d57f70de7a17ed8f07997080f98940ca538f43e1ca4b95a835221d",
    )

    http_archive(
        name = "libevent",
        urls = [
            "https://github.com/libevent/libevent/releases/download/release-2.1.12-stable/libevent-2.1.12-stable.tar.gz",
        ],
        strip_prefix = "libevent-2.1.12-stable",
        build_file = Label("//third_party:libevent.BUILD"),
    )

    http_archive(
        name = "flex",
        build_file = Label("//third_party/flex:flex.BUILD"),
        urls = ["https://github.com/westes/flex/releases/download/v2.6.4/flex-2.6.4.tar.gz"],
        sha256 = "e87aae032bf07c26f85ac0ed3250998c37621d95f8bd748b31f15b33c45ee995",
        strip_prefix = "flex-2.6.4",
    )

    http_archive(
        name = "com_google_absl",
        urls = [
            "https://github.com/abseil/abseil-cpp/archive/refs/tags/20211102.0.tar.gz",
        ],
        strip_prefix = "abseil-cpp-20211102.0",
        sha256 = "dcf71b9cba8dc0ca9940c4b316a0c796be8fab42b070bb6b7cab62b48f0e66c4",
    )

    http_archive(
        name = "cityhash",
        urls = [
            "https://github.com/google/cityhash/archive/8af9b8c2b889d80c22d6bc26ba0df1afb79a30db.tar.gz",
        ],
        type = "tar.gz",
        strip_prefix = "cityhash-8af9b8c2b889d80c22d6bc26ba0df1afb79a30db",
        build_file = Label("//third_party:cityhash.BUILD"),
    )

    git_repository(
        name = "oneTBB",
        branch = "master",
        remote = "https://github.com/oneapi-src/oneTBB/",
    )

    http_archive(
        name = "oneDNN",
        build_file = Label("//third_party:oneDNN.BUILD"),
        strip_prefix = "oneDNN-" + "2.5",
        urls = [
            "https://github.com//oneapi-src/oneDNN/archive/refs/tags/v{}.tar.gz".format("2.5"),
        ],
    )

    http_archive(
        name = "apache_apr",
        urls = [
            "https://ftp.wayne.edu/apache//apr/apr-1.7.0.tar.gz",
        ],
        strip_prefix = "apr-1.7.0",
        build_file = Label("//third_party:apr.BUILD"),
    )

    http_archive(
        name = "apache_aprutil",
        urls = [
            "https://ftp.wayne.edu/apache//apr/apr-util-1.6.1.tar.gz",
        ],
        strip_prefix = "apr-util-1.6.1",
        build_file = Label("//third_party:aprutil.BUILD"),
    )

    http_archive(
        name = "libexpat",
        urls = [
            "https://github.com//libexpat/libexpat/releases/download/R_2_4_1/expat-2.4.1.tar.gz",
        ],
        strip_prefix = "expat-{}".format("2.4.1"),
        build_file = Label("//third_party:expat.BUILD"),
    )

    http_archive(
        name = "apache_log4cxx",
        urls = [
            # "https://dlcdn.apache.org/logging/log4cxx/0.12.1/apache-log4cxx-0.12.1.zip",
            "https://archive.apache.org/dist/logging/log4cxx/0.11.0/apache-log4cxx-0.11.0.zip",
        ],
        strip_prefix = "apache-log4cxx-0.11.0",
        build_file = Label("//third_party:log4cxx.BUILD"),
    )

    http_archive(
        name = "uuid",
        urls = [
            "https://mirrors.edge.kernel.org/pub/linux/utils/util-linux/v2.35/util-linux-{}.tar.gz".format("2.35.1"),
        ],
        strip_prefix = "util-linux-" + "2.35.1",
        build_file = Label("//third_party:uuid.BUILD"),
    )

    http_archive(
        name = "eigen",
        urls = [
            "https://gitlab.com/libeigen/eigen/-/archive/{tag}/eigen-{tag}.tar.gz".format(tag = "3.4.0"),
        ],
        strip_prefix = "eigen-{}".format("3.4.0"),
        build_file = Label("//third_party:eigen.BUILD"),
    )

    http_archive(
        name = "openblas",
        urls = [
            "https://github.com/xianyi/OpenBLAS/releases/download/v{tag}/OpenBLAS-{tag}.tar.gz".format(tag = "0.3.20"),
        ],
        type = "tar.gz",
        strip_prefix = "OpenBLAS-{}".format("0.3.20"),
        # sha256 = "947f51bfe50c2a0749304fbe373e00e7637600b0a47b78a51382aeb30ca08562",
        build_file = Label("//third_party:openblas.BUILD"),
    )

    http_archive(
        name = "com_github_google_flatbuffers",
        urls = [
            "https://github.com/google/flatbuffers/archive/v{}.tar.gz".format("1.12.0"),
        ],
        strip_prefix = "flatbuffers-" + "1.12.0",
        sha256 = "62f2223fb9181d1d6338451375628975775f7522185266cd5296571ac152bc45",
    )

    http_archive(
        name = "jemalloc",
        sha256 = "ed51b0b37098af4ca6ed31c22324635263f8ad6471889e0592a9c0dba9136aea",
        strip_prefix = "jemalloc-5.2.1",
        build_file = Label("//third_party:jemalloc.BUILD"),
        urls = ["https://github.com/jemalloc/jemalloc/archive/5.2.1.tar.gz"],
    )

    ARROW_VERSION = "18e7cbf75f9b2cb58571a33f0dbd8b4ed954f23b"
    http_archive(
        name = "com_github_apache_arrow",
        build_file = Label("//third_party/arrow:arrow.BUILD"),
        strip_prefix = "arrow-" + ARROW_VERSION,
        urls = [
            "https://github.com/apache/arrow/archive/{}.zip".format(ARROW_VERSION),
        ],
    )

    XSMID_VERSION = "202064d8a4e7f41684bfd91a5bed88cb54aa0ed9"
    http_archive(
        name = "com_github_xtensorstack_xsimd",
        urls = [
            "https://github.com/xtensor-stack/xsimd/archive/{}.zip".format(XSMID_VERSION),
        ],
        strip_prefix = "xsimd-" + XSMID_VERSION,
        build_file = Label("//third_party:xsimd.BUILD"),
    )

    http_archive(
        name = "com_github_opencv",
        strip_prefix = "opencv-{}".format("4.5.3"),
        urls = [
            "https://github.com/opencv/opencv/archive/refs/tags/{}.tar.gz".format("4.5.3"),
        ],
        build_file = Label("//third_party:opencv.BUILD"),
    )

    http_archive(
        name = "org_gnu_bison",
        urls = [
            "https://ftp.gnu.org/gnu/bison/bison-3.5.tar.gz",
            "https://mirror.bazel.build/ftp.gnu.org/gnu/bison/bison-3.5.tar.gz",
        ],
        strip_prefix = "bison-3.5",
        build_file = Label("//third_party:bison.BUILD"),
    )

    http_archive(
        name = "org_gnu_m4",
        urls = [
            "https://ftp.gnu.org/gnu/m4/m4-1.4.18.tar.gz",
        ],
        strip_prefix = "m4-1.4.18",
        build_file = Label("//third_party/m4:m4.BUILD"),
        patch_args = ["-p1"],
        patches = ["//third_party/m4:m4.patch"],
    )

    http_archive(
        name = "com_github_axboe_liburing",
        build_file = Label("//third_party/liburing:liburing.BUILD"),
        urls = [
            "https://github.com/axboe/liburing/archive/liburing-0.6.tar.gz",
        ],
        strip_prefix = "liburing-liburing-0.6",
        patch_args = [
            "-p0",
        ],
        patches = [
            Label("//third_party/liburing:liburing.patch"),
        ],
    )

    git_repository(
        name = "rules_bison",
        remote = "https://github.com/jmillikin/rules_bison",
        tag = "v0.2",
        patch_cmds = ["sed -i '83d' bison/bison.bzl"],
    )

    http_archive(
        name = "rules_m4",
        urls = ["https://github.com/jmillikin/rules_m4/releases/download/v0.2/rules_m4-v0.2.tar.xz"],
        sha256 = "c67fa9891bb19e9e6c1050003ba648d35383b8cb3c9572f397ad24040fb7f0eb",
    )

    http_archive(
        name = "rules_flex",
        urls = ["https://github.com/jmillikin/rules_flex/releases/download/v0.2/rules_flex-v0.2.tar.xz"],
        sha256 = "f1685512937c2e33a7ebc4d5c6cf38ed282c2ce3b7a9c7c0b542db7e5db59d52",
        patch_cmds = ["sed -i '76d' flex/flex.bzl"],
    )

    http_archive(
        name = "com_pagure_libaio",
        build_file = Label("//third_party:libaio.BUILD"),
        urls = ["https://pagure.io/libaio/archive/libaio-0.3.111/libaio-libaio-0.3.111.tar.gz"],
        sha256 = "e6bc17cba66e59085e670fea238ad095766b412561f90b354eb4012d851730ba",
        strip_prefix = "libaio-libaio-0.3.111",
        patches = [
            Label("//third_party:libaio.patch"),
        ],
        patch_args = [
            "-p1",
        ],
    )

    http_archive(
        name = "libdwarf",
        build_file = Label("//third_party:libdwarf.BUILD"),
        urls = [
            "https://www.prevanders.net/libdwarf-0.3.3.tar.xz",
        ],
        # sha256 = "86119a9f7c409dc31e02d12c1b3906b1fce0dcb4db3d7e65ebe1bae585cf08f8",
        strip_prefix = "libdwarf-0.3.3",
    )

    http_archive(
        name = "libunwind",
        build_file = Label("//third_party:libunwind.BUILD"),
        urls = ["https://github.com/libunwind/libunwind/releases/download/v1.5/libunwind-1.5.0.tar.gz"],
        sha256 = "90337653d92d4a13de590781371c604f9031cdb50520366aa1e3a91e1efb1017",
        strip_prefix = "libunwind-1.5.0",
    )

    http_archive(
        name = "libiberty",
        urls = [
            "https://ftpmirror.gnu.org/gcc/gcc-11.2.0/gcc-11.2.0.tar.xz",
            "https://ftp.gnu.org/gnu/gcc/gcc-11.2.0/gcc-11.2.0.tar.gz",
            "http://mirrors.concertpass.com/gcc/releases/gcc-11.2.0/gcc-11.2.0.tar.gz",
        ],
        strip_prefix = "gcc-11.2.0",
        build_file = Label("//third_party:libiberty.BUILD"),
        # sha256 = "0a07b8dfc388d5da81fc02e356e6c78a896544c96cc40e8cca41e180a814e16c",
    )

    PROXYGEN_VERSION = "2022.01.31.00"
    http_archive(
        name = "com_github_facebook_proxygen",
        build_file = Label("//third_party:proxygen.BUILD"),
        urls = [
            "https://github.com/facebook/proxygen/archive/v{tag}.tar.gz".format(tag = PROXYGEN_VERSION),
        ],
        # sha256 = "c8ac12aed526c3e67b9424a358dac150958e727feb2b3d1b8b3407ea0d53e315",
        strip_prefix = "proxygen-" + PROXYGEN_VERSION,
    )

    WANGLE_VERSION = "2022.01.31.00"
    http_archive(
        name = "com_github_facebook_wangle",
        build_file = Label("//third_party:wangle.BUILD"),
        urls = [
            "https://github.com/facebook/wangle/archive/v{tag}.tar.gz".format(tag = WANGLE_VERSION),
        ],
        strip_prefix = "wangle-" + WANGLE_VERSION,
        # sha256 = "a046dfea92f453bd12b28dad287a7eb86e782c4db9518b90c33c5320b3868f0b",
    )

    FIZZ_VERSION = "2022.01.31.00"
    http_archive(
        name = "com_github_facebookincubator_fizz",
        build_file = Label("//third_party:fizz.BUILD"),
        strip_prefix = "fizz-" + FIZZ_VERSION,
        urls = [
            "https://github.com/facebookincubator/fizz/archive/v{tag}.tar.gz".format(tag = FIZZ_VERSION),
        ],
        # sha256 = "62d3f5ff24c32e373771ee33a7c4f394b56536d941ac476f774f62b6189d6ce5",
    )

    http_archive(
        name = "com_github_facebook_fatal",
        build_file = Label("//third_party:fatal.BUILD"),
        strip_prefix = "fatal-2022.02.07.00",
        urls = ["https://github.com/facebook/fatal/archive/refs/tags/v2022.02.07.00.tar.gz"],
        # sha256 = "62d3f5ff24c32e373771ee33a7c4f394b56536d941ac476f774f62b6189d6ce5",
    )

    http_archive(
        name = "com_github_cyan4973_xxhash",
        build_file = Label("//third_party:xxhash.BUILD"),
        strip_prefix = "xxHash-0.8.1",
        urls = ["https://github.com/Cyan4973/xxHash/archive/refs/tags/v0.8.1.tar.gz"],
        # sha256 = "62d3f5ff24c32e373771ee33a7c4f394b56536d941ac476f774f62b6189d6ce5",
    )

    new_git_repository(
        name = "com_github_catchorg_Catch2",
        remote = "https://github.com/catchorg/Catch2",
        build_file = Label("//third_party:catch2.BUILD"),
        patch_cmds = [
            "mv src/catch2/catch_all.hpp src/catch2/catch.hpp",
        ],
        commit = "7cf2f88e50f0d1de324489c31db0314188423b6d",
    )

    git_repository(
        name = "com_github_google_brotli",
        remote = "https://github.com/google/brotli",
        tag = "v1.0.9",
    )

    # http_archive(
    #     name = "io_opentelemetry_cpp",
    #     build_file = Label("//third_party:opentelemetry.BUILD"),
    #     strip_prefix = "opentelemetry-cpp-1.2.0",
    #     urls = ["https://github.com/open-telemetry/opentelemetry-cpp/archive/refs/tags/v1.2.0.tar.gz"],
    # )

    http_archive(
        name = "cares",
        build_file = Label("//third_party:cares.BUILD"),
        sha256 = "62dd12f0557918f89ad6f5b759f0bf4727174ae9979499f5452c02be38d9d3e8",
        strip_prefix = "c-ares-cares-1_14_0",
        urls = [
            "https://github.com/c-ares/c-ares/archive/cares-1_14_0.tar.gz",
        ],
    )

    # http_archive(
    #     name = "com_github_curl_curl",
    #     build_file = "//third_party:curl.BUILD",
    #     sha256 = "ac8e1087711084548d788ef18b9b732c8de887457b81f616fc681d1044b32f98",
    #     strip_prefix = "curl-7.81.0",
    #     urls = [
    #         "https://curl.se/download/curl-7.81.0.tar.gz",
    #         "https://github.com/curl/curl/releases/download/curl-7_81_0/curl-7.81.0.tar.gz",
    #     ],
    # )

    # ===== ICU dependency =====
    # Note: This overrides the dependency from TensorFlow with a version
    # that contains all data.
    # http_archive(
    #     name = "icu",
    #     strip_prefix = "icu-release-64-2",
    #     sha256 = "dfc62618aa4bd3ca14a3df548cd65fe393155edd213e49c39f3a30ccd618fc27",
    #     urls = [
    #         "https://storage.googleapis.com/mirror.tensorflow.org/github.com/unicode-org/icu/archive/release-64-2.zip",
    #         "https://github.com/unicode-org/icu/archive/release-64-2.zip",
    #     ],
    #     build_file = "//third_party/icu:BUILD",
    #     patches = ["//third_party/icu:data.patch"],
    #     patch_args = ["-p1", "-s"],
    # )

    # ===== TF.Text dependencies
    # NOTE: Before updating this version, you must update the test model
    # and double check all custom ops have a test:
    # https://github.com/tensorflow/text/blob/master/oss_scripts/model_server/save_models.py
    # http_archive(
    #     name = "org_tensorflow_text",
    #     sha256 = "0991ff93959a0e3ec7d16ba9d9ff9b4463bba565da402f1460cdbfa731112034",
    #     strip_prefix = "text-2.6.0",
    #     url = "https://github.com/tensorflow/text/archive/v2.6.0.zip",
    #     patches = ["@//third_party/tf_text:tftext.patch"],
    #     patch_args = ["-p1"],
    #     repo_mapping = {"@com_google_re2": "@com_googlesource_code_re2"},
    # )

    # http_archive(
    #     name = "com_google_sentencepiece",
    #     strip_prefix = "sentencepiece-1.0.0",
    #     sha256 = "c05901f30a1d0ed64cbcf40eba08e48894e1b0e985777217b7c9036cac631346",
    #     url = "https://github.com/google/sentencepiece/archive/1.0.0.zip",
    # )

    new_git_repository(
        name = "msgpack",
        remote = "https://github.com/msgpack/msgpack-c",
        branch = "cpp_master",
        build_file = Label("//third_party:msgpack.BUILD"),
    )

    new_git_repository(
        name = "com_github_dmlc_xgboost",
        remote = "https://github.com/dmlc/xgboost",
        branch = "master",
        build_file = Label("//third_party:xgboost.BUILD"),
        recursive_init_submodules = True,
    )

    new_git_repository(
        name = "com_github_dmlc_dmlc-core",
        remote = "https://github.com/dmlc/dmlc-core",
        branch = "main",
        build_file = Label("//third_party:dmlc-core.BUILD"),
    )

    http_archive(
        name = "sparsehash_c11",
        build_file = Label("//third_party:sparsehash_c11.BUILD"),
        sha256 = "d4a43cad1e27646ff0ef3a8ce3e18540dbcb1fdec6cc1d1cb9b5095a9ca2a755",
        strip_prefix = "sparsehash-c11-2.11.1",
        urls = [
            "https://github.com/sparsehash/sparsehash-c11/archive/v2.11.1.tar.gz",
        ],
    )

    BM_COMMIT = "1.6.1"
    http_archive(
        name = "com_google_benchmark",
        sha256 = "6132883bc8c9b0df5375b16ab520fac1a85dc9e4cf5be59480448ece74b278d4",
        strip_prefix = "benchmark-{}".format(BM_COMMIT),
        build_file = Label("//third_party:benchmark.BUILD"),
        urls = [
            "https://github.com/google/benchmark/archive/refs/tags/v{}.tar.gz".format(BM_COMMIT),
        ],
    )

    tf_http_archive(
        name = "clog",
        strip_prefix = "cpuinfo-d5e37adf1406cf899d7d9ec1d317c47506ccb970",
        sha256 = "3f2dc1970f397a0e59db72f9fca6ff144b216895c1d606f6c94a507c1e53a025",
        urls = tf_mirror_urls("https://github.com/pytorch/cpuinfo/archive/d5e37adf1406cf899d7d9ec1d317c47506ccb970.tar.gz"),
        build_file = "//third_party:clog.BUILD",
    )

    tf_http_archive(
        name = "cpuinfo",
        strip_prefix = "cpuinfo-5916273f79a21551890fd3d56fc5375a78d1598d",
        sha256 = "2a160c527d3c58085ce260f34f9e2b161adc009b34186a2baf24e74376e89e6d",
        urls = tf_mirror_urls("https://github.com/pytorch/cpuinfo/archive/5916273f79a21551890fd3d56fc5375a78d1598d.zip"),
        build_file = "//third_party:cpuinfo.BUILD",
    )

    tf_http_archive(
        name = "dlpack",
        strip_prefix = "dlpack-790d7a083520398268d92d0bd61cf85dfa32ee98",
        sha256 = "147cc89904375dcd0b0d664a2b72dfadbb02058800ad8cba84516094bc406208",
        urls = tf_mirror_urls("https://github.com/dmlc/dlpack/archive/790d7a083520398268d92d0bd61cf85dfa32ee98.tar.gz"),
        build_file = "//third_party:dlpack.BUILD",
    )

    git_repository(
        name = "com_grail_bazel_compdb",
        remote = "https://github.com/grailbio/bazel-compilation-database",
        tag = "0.5.2",
    )

def workspace():
    # Check the bazel version before executing any repository rules, in case
    # those rules rely on the version we require here.
    check_bazel_version_at_least("1.0.0")

    # Initialize toolchains and platforms.
    _tf_toolchains()

    # Import third party repositories according to go/tfbr-thirdparty.
    _initialize_third_party()

    # Import all other repositories. This should happen before initializing
    # any external repositories, because those come with their own
    # dependencies. Those recursive dependencies will only be imported if they
    # don't already exist (at least if the external repository macros were
    # written according to common practice to query native.existing_rule()).
    _tf_repositories()

    tfrt_dependencies()

    # TODO(rostam): Delete after the release of Bazel built-in cc_shared_library.
    # Initializes Bazel package rules' external dependencies.
    rules_pkg_dependencies()

    rules_foreign_cc_dependencies()

# Alias so it can be loaded without assigning to a different symbol to prevent
# shadowing previous loads and trigger a buildifier warning.
tf_workspace2 = workspace
