class Pocl < Formula
  desc "Portable Computing Language"
  homepage "https://portablecl.org/"
  license "MIT"

  stable do
    url "https://mirror.ghproxy.com/https://github.com/pocl/pocl/archive/refs/tags/v7.1.tar.gz"
    sha256 "1110057cb0736c74819ad65238655a03f7b93403a0ca60cdd8849082f515ca25"
    depends_on "llvm@20" # TODO: use `llvm` next release, https://github.com/pocl/pocl/pull/1982
  end

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_tahoe:   "7b0c3f27e0c8baf1ec7d4ba9ccc9fa1212e7be869f30e278a15a56b005f22943"
    sha256 arm64_sequoia: "fd7951bdc3932512d48d8ad4b8802cdecdfb87d42ecf760280619012a2fb5a8c"
    sha256 arm64_sonoma:  "3f3b045f08c3142ca2ade8be8b14b64c6cae133196697cdb919df5baf26df642"
    sha256 sonoma:        "5e807e89316b1d8c166bc4e03aa94de4b0ee920397662c1c352b6d00647a2928"
    sha256 arm64_linux:   "059617e6e826814a699a313e60fda741bdf35350dba135ac26bc41421e66a01b"
    sha256 x86_64_linux:  "d39dc69fdfb552e6fa14b896d06c2c00ed65b40fea7711fec5d5895701b78287"
  end

  head do
    url "https://github.com/pocl/pocl.git", branch: "main"
    depends_on "llvm"
  end

  depends_on "cmake" => :build
  depends_on "opencl-headers" => :build
  depends_on "pkgconf" => :build
  depends_on "hwloc"
  depends_on "opencl-icd-loader"
  uses_from_macos "python" => :build

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    # Install the ICD into #{prefix}/etc rather than #{etc} as it contains the realpath
    # to the shared library and needs to be kept up-to-date to work with an ICD loader.
    # This relies on `brew link` automatically creating and updating #{etc} symlinks.
    rpaths = [loader_path, rpath(source: lib/"pocl")]
    rpaths << llvm.opt_lib.to_s if OS.linux?
    args = %W[
      -DPOCL_INSTALL_ICD_VENDORDIR=#{prefix}/etc/OpenCL/vendors
      -DCMAKE_INSTALL_RPATH=#{rpaths.join(";")}
      -DENABLE_EXAMPLES=OFF
      -DENABLE_TESTS=OFF
      -DINSTALL_OPENCL_HEADERS=OFF
      -DWITH_LLVM_CONFIG=#{llvm.opt_bin}/llvm-config
      -DLLVM_PREFIX=#{llvm.opt_prefix}
      -DLLVM_BINDIR=#{llvm.opt_bin}
      -DLLVM_LIBDIR=#{llvm.opt_lib}
      -DLLVM_INCLUDEDIR=#{llvm.opt_include}
    ]
    if build.bottle?
      args << if Hardware::CPU.intel?
        # Only x86_64 supports "distro" which allows runtime detection of SSE/AVX
        "-DKERNELLIB_HOST_CPU_VARIANTS=distro"
      elsif OS.mac?
        "-DLLC_HOST_CPU=apple-m1"
      else
        "-DLLC_HOST_CPU=generic"
      end
    end

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    (pkgshare/"examples").install "examples/poclcc"
  end

  test do
    ENV["OCL_ICD_VENDORS"] = "#{opt_prefix}/etc/OpenCL/vendors" # Ignore any other ICD that may be installed
    cp pkgshare/"examples/poclcc/poclcc.cl", testpath
    system bin/"poclcc", "-o", "poclcc.cl.pocl", "poclcc.cl"
    assert_path_exists testpath/"poclcc.cl.pocl"
    # Make sure that CMake found our OpenCL headers and didn't install a copy
    refute_path_exists include/"OpenCL"
  end
end
