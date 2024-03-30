class Vineyard < Formula
  include Language::Python::Virtualenv

  desc "In-memory immutable data manager. (Project under CNCF)"
  homepage "https://v6d.io"
  url "https://mirror.ghproxy.com/https://github.com/v6d-io/v6d/releases/download/v0.21.5/v6d-0.21.5.tar.gz"
  sha256 "c434f61e71fb5e414add093b302375f27084dc03800e026019199db984183036"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256                               arm64_sonoma:   "d2eb18bd877308b20832e9522eeb7ac5cfaa58a868e1c48172ee146e75fc4c56"
    sha256                               arm64_ventura:  "9c574acc69719bafb8a3443c1cdd413644c67e241addf8196bd0087198a11e0c"
    sha256                               arm64_monterey: "aaa03442a75dbc85795896836a31cedb82fe5fd9a65a7701750dd58071b76dee"
    sha256                               sonoma:         "eaba0b2adc8f317f9e913319eaa020d7182bbe63551b730859a986252a967f86"
    sha256                               ventura:        "27c7e40b494d6ea16119f27935f167f8a478fbc542a89287bdcd0545f777c021"
    sha256                               monterey:       "b2dd35f487cb2d6be362a996e705ea839ac68de08aaecc77432e926947c32b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c32f186ff283c322aa52645a4218bbb948f1b2eec62d07a4fd9e2dfb7ea85b07"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "llvm" => [:build, :test]
  depends_on "python-setuptools" => :build
  depends_on "python@3.12" => :build
  depends_on "apache-arrow"
  depends_on "boost"
  depends_on "etcd"
  depends_on "etcd-cpp-apiv3"
  depends_on "gflags"
  depends_on "glog"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "libgrape-lite"
  depends_on "open-mpi"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "redis"

  fails_with gcc: "5"

  def install
    python = "python3.12"
    # LLVM is keg-only.
    ENV.prepend_path "PYTHONPATH", Formula["llvm"].opt_prefix/Language::Python.site_packages(python)

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=17",
                    "-DCMAKE_CXX_STANDARD_REQUIRED=TRUE",
                    "-DPYTHON_EXECUTABLE=#{which(python)}",
                    "-DUSE_EXTERNAL_ETCD_LIBS=ON",
                    "-DUSE_EXTERNAL_REDIS_LIBS=ON",
                    "-DUSE_EXTERNAL_HIREDIS_LIBS=ON",
                    "-DBUILD_VINEYARD_TESTS=OFF",
                    "-DUSE_LIBUNWIND=OFF",
                    "-DLIBGRAPELITE_INCLUDE_DIRS=#{Formula["libgrape-lite"].opt_include}",
                    "-DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include <memory>

      #include <vineyard/client/client.h>

      int main(int argc, char **argv) {
        vineyard::Client client;
        VINEYARD_CHECK_OK(client.Connect(argv[1]));

        std::shared_ptr<vineyard::InstanceStatus> status;
        VINEYARD_CHECK_OK(client.InstanceStatus(status));
        std::cout << "vineyard instance is: " << status->instance_id << std::endl;

        return 0;
      }
    EOS

    (testpath/"CMakeLists.txt").write <<~EOS
      cmake_minimum_required(VERSION 3.5)

      project(vineyard-test LANGUAGES C CXX)

      find_package(vineyard REQUIRED)

      add_executable(vineyard-test ${CMAKE_CURRENT_SOURCE_DIR}/test.cc)
      target_include_directories(vineyard-test PRIVATE ${VINEYARD_INCLUDE_DIRS})
      target_link_libraries(vineyard-test PRIVATE ${VINEYARD_LIBRARIES})
    EOS

    # Work around an Xcode 15 linker issue which causes linkage against LLVM's
    # libunwind due to it being present in a library search path.
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    # Remove Homebrew's lib directory from LDFLAGS as it is not available during
    # `shell_output`.
    ENV.remove "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # macos AppleClang doesn't support -fopenmp
    system "cmake", "-S", testpath, "-B", testpath/"build",
                    "-DCMAKE_C_COMPILER=#{Formula["llvm"].bin}/clang",
                    "-DCMAKE_CXX_COMPILER=#{Formula["llvm"].bin}/clang++",
                    *std_cmake_args
    system "cmake", "--build", testpath/"build"

    # prepare vineyardd
    vineyardd_pid = spawn bin/"vineyardd", "--norpc",
                                           "--meta=local",
                                           "--socket=#{testpath}/vineyard.sock"

    # sleep to let vineyardd get its wits about it
    sleep 10

    assert_equal("vineyard instance is: 0\n",
                 shell_output("#{testpath}/build/vineyard-test #{testpath}/vineyard.sock"))
  ensure
    # clean up the vineyardd process before we leave
    Process.kill("HUP", vineyardd_pid)
  end
end
