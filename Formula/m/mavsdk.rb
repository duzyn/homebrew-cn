class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v2.8.0",
      revision: "a041ea4d4e14321dcbf6074e7745663647cda1eb"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ad52f11e6ed7660695ac296e13ccc24e6477608a23c741b1b6c468cf65b94a9f"
    sha256 cellar: :any,                 arm64_ventura:  "06a4e8dcfc57ecfa8fc6e3a654c5351f16705a67a1e619fa11f0b21a33ab6d8f"
    sha256 cellar: :any,                 arm64_monterey: "790e90216ff82fcf570ab132f504e6a890f91968b9addf0144bbb7639f785566"
    sha256 cellar: :any,                 sonoma:         "df8a0f532a02b7b37360f51d6a8fea624042c4b547c5122f4c544e1cbe983f57"
    sha256 cellar: :any,                 ventura:        "65959935982b587a0e1caf3c6ccd2e84b66990d9f8ea1321b00cda853408155d"
    sha256 cellar: :any,                 monterey:       "0cf4e768a91c8b8cfe1d47d019307122f137a7869e77c6600db4062b06dffed6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da4c95e8ae3f2ee1b8cf9669dd6a61ed3e1b5755c5776f080deaee081bdc81fe"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__status(std::__1::__fs::filesystem::path const&, std::__1::error_code*)"
    EOS
  end

  fails_with gcc: "5"

  # MAVLINK_GIT_HASH in https://github.com/mavlink/MAVSDK/blob/v#{version}/third_party/mavlink/CMakeLists.txt
  resource "mavlink" do
    url "https://github.com/mavlink/mavlink.git",
        revision: "9840105a275db1f48f9711d0fb861e8bf77a2245"
  end

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Regenerate files to support newer protobuf
    system "tools/generate_from_protos.sh"

    resource("mavlink").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DPython_EXECUTABLE=#{which("python3.12")}",
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    # Source build adapted from
    # https://mavsdk.mavlink.io/develop/en/contributing/build.html
    system "cmake", "-S", ".", "-B", "build",
                    "-DSUPERBUILD=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_MAVSDK_SERVER=ON",
                    "-DBUILD_TESTS=OFF",
                    "-DVERSION_STR=v#{version}-#{tap.user}",
                    "-DCMAKE_PREFIX_PATH=#{libexec}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <mavsdk/mavsdk.h>
      using namespace mavsdk;
      int main() {
          Mavsdk mavsdk{Mavsdk::Configuration{Mavsdk::ComponentType::GroundStation}};
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", testpath/"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output("./test").chomp

    assert_equal "Usage: #{bin}/mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
