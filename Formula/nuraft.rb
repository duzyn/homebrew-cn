class Nuraft < Formula
  desc "C++ implementation of Raft core logic as a replication library"
  homepage "https://github.com/eBay/NuRaft"
  url "https://github.com/eBay/NuRaft/archive/v1.3.0.tar.gz"
  sha256 "e09b53553678ddf8fa4823c461fe303e7631d30da0d45f63f90e7652b7e440bb"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "28d93fd60657c2a7eeb21be7fa86c7e129d9e036b2cdac6391b71e156b76b28e"
    sha256 cellar: :any,                 arm64_monterey: "d07ece97bc536bc22f77e009c4c09d467cf84c848f98f449d382a217222cf8df"
    sha256 cellar: :any,                 arm64_big_sur:  "ef7e06e935ab63bb8d7001639846922d2a12c4c902783a198e65ed4f8d8d6c3c"
    sha256 cellar: :any,                 ventura:        "486c038044bb14e9afdd47e4470fc92c5bad6ba5e21334ecec94cc6829ab6c3a"
    sha256 cellar: :any,                 monterey:       "e1988cf74f43cfdfc746d37ff5ffa461421aa0602e28227a5715e4e7565f3598"
    sha256 cellar: :any,                 big_sur:        "c048da37867c7c846bbd0ef91c81e62c37e73b2e55ed5080f479940f8ad91ed5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "272f2298f6b55efe1f93e63c2d44af4d317499ea1e5b2eaf87acf8107ea2eb30"
  end

  depends_on "cmake" => :build
  depends_on "asio"
  depends_on "openssl@3"

  def install
    # We override OPENSSL_LIBRARY_PATH to avoid statically linking to OpenSSL
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DOPENSSL_LIBRARY_PATH="
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/.", testpath
    system ENV.cxx, "-std=c++11", "-o", "test",
                    "quick_start.cxx", "logger.cc", "in_memory_log_store.cxx",
                    "-I#{include}/libnuraft", "-I#{testpath}/echo",
                    "-I#{Formula["openssl@3"].opt_include}",
                    "-L#{lib}", "-lnuraft",
                    "-L#{Formula["openssl@3"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "hello world", shell_output("./test")
  end
end
