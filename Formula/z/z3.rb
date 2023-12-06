class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  license "MIT"
  head "https://github.com/Z3Prover/z3.git", branch: "master"

  stable do
    url "https://mirror.ghproxy.com/https://github.com/Z3Prover/z3/archive/refs/tags/z3-4.12.3.tar.gz"
    sha256 "61670733eb7a74eeca13033244cbec2c4098dca24a6fa3df0e7ae12ee8f33d9c"

    # build patch to use built-in `importlib.resources` avail in py3.9+
    # upstream PR ref, https://github.com/Z3Prover/z3/pull/7042
    patch do
      url "https://github.com/Z3Prover/z3/commit/03ae6d86cb4db88c71d6b245e29400e9a44cb59f.patch?full_index=1"
      sha256 "bc574bf4a6de35a41e396f42b3e82f2f563bcd017acb536a86958a1e44b0fb9a"
    end
  end

  livecheck do
    url :stable
    regex(/z3[._-]v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c4d6e0a9b71a57802fb548d03592481c0d67e373f79ce23c76869b57a1f9c9d4"
    sha256 cellar: :any,                 arm64_ventura:  "484665bf9ad7b8eb858adfe9ae3340f48e9aeea8b44d45ded9ab51a4e50d9405"
    sha256 cellar: :any,                 arm64_monterey: "b271a212e4388ef73a37799a4e90a4b5b03232bbda65887ec6f05e8730b8e74e"
    sha256 cellar: :any,                 sonoma:         "fb63aa21ad0dc59176294c4bf1f525968e2aad21ab6d6da3dd7bb54cdbc41ea8"
    sha256 cellar: :any,                 ventura:        "1b613299520702b4b80999165909607c97c8b612d280b109f979dd4c1ecc671a"
    sha256 cellar: :any,                 monterey:       "d72efca19ebe3a17a6035fbd26fb47d215f74d77ff5c6c1cb9ce3969386a2c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e2c8e3996f03ad8383905b81628760de7f583929bf5f256e87689a3cd0d0b94"
  end

  depends_on "cmake" => :build
  # Has Python bindings but are supplementary to the main library
  # which does not need Python.
  depends_on "python@3.12" => [:build, :test]
  depends_on "python-setuptools" => :test

  fails_with gcc: "5"

  fails_with :clang do
    build 1000
    cause <<-EOS
      Z3 uses modern C++17 features, which is not supported by Apple's clang until
      later macOS (10.14).
    EOS
  end

  def python3
    which("python3.12")
  end

  def install
    args = %W[
      -DZ3_LINK_TIME_OPTIMIZATION=ON
      -DZ3_INCLUDE_GIT_DESCRIBE=OFF
      -DZ3_INCLUDE_GIT_HASH=OFF
      -DZ3_INSTALL_PYTHON_BINDINGS=ON
      -DZ3_BUILD_EXECUTABLE=ON
      -DZ3_BUILD_TEST_EXECUTABLES=OFF
      -DZ3_BUILD_PYTHON_BINDINGS=ON
      -DZ3_BUILD_DOTNET_BINDINGS=OFF
      -DZ3_BUILD_JAVA_BINDINGS=OFF
      -DZ3_USE_LIB_GMP=OFF
      -DPYTHON_EXECUTABLE=#{python3}
      -DCMAKE_INSTALL_PYTHON_PKG_DIR=#{Language::Python.site_packages(python3)}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system "make", "-C", "contrib/qprofdiff"
    bin.install "contrib/qprofdiff/qprofdiff"

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, pkgshare/"examples/c/test_capi.c", "-I#{include}",
                   "-L#{lib}", "-lz3", "-o", testpath/"test"
    system "./test"
    assert_equal version.to_s, shell_output("#{python3} -c 'import z3; print(z3.get_version_string())'").strip
  end
end
