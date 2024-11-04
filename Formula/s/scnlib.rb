class Scnlib < Formula
  desc "Scanf for modern C++"
  homepage "https://scnlib.dev"
  url "https://mirror.ghproxy.com/https://github.com/eliaskosunen/scnlib/archive/refs/tags/v3.0.2.tar.gz"
  sha256 "27f17420ddad6971339e6d5db0d915204181c31f5cb0e92a63b9998d98e2852b"
  license "Apache-2.0"
  head "https://github.com/eliaskosunen/scnlib.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "427dad55a2d75064c8338bcfc2a77bd3402b8401712c43d8deb0dd05f81edf31"
    sha256 cellar: :any, arm64_sonoma:  "d191d4c88331f1252745b2b468ebffbd6d29ce09b44b967042c3ed31ec405899"
    sha256 cellar: :any, arm64_ventura: "15456b80d6c26e06b65d539ec9bb2a0bc8843b20effeca0bb4c7e5b37cdc6ec7"
    sha256 cellar: :any, sonoma:        "aacb88d942a62fd3955a6ebfe78e59e5595f2ab802d33d93804a82a1912d5fb4"
    sha256 cellar: :any, ventura:       "b48b42cb79dccf99cba58035f7f0617b59ad47a9d9679395a438e767be6c5823"
  end

  depends_on "cmake" => :build
  depends_on "simdutf"

  def install
    args = %w[
      -DBUILD_SHARED_LIBS=ON
      -DSCN_TESTS=OFF
      -DSCN_DOCS=OFF
      -DSCN_EXAMPLES=OFF
      -DSCN_BENCHMARKS=OFF
      -DSCN_BENCHMARKS_BUILDTIME=OFF
      -DSCN_BENCHMARKS_BINARYSIZE=OFF
      -DSCN_USE_EXTERNAL_SIMDUTF=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <scn/scan.h>
      #include <cstdlib>
      #include <string>

      int main()
      {
        constexpr int expected = 123456;
        auto [result] = scn::scan<int>(std::to_string(expected), "{}")->values();
        return result == expected ? EXIT_SUCCESS : EXIT_FAILURE;
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", "-I#{include}", "-L#{lib}", "-lscn"
    system "./test"
  end
end
