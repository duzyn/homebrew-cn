class Valijson < Formula
  desc "Header-only C++ library for JSON Schema validation"
  homepage "https://github.com/tristanpenman/valijson"
  url "https://mirror.ghproxy.com/https://github.com/tristanpenman/valijson/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "2890921a1cdceae2b065c2efaddca72fc2027ceedda92404e44276b01dfb2b7e"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e8b329192533275a0c36189992fef01d3f587cee2919dac313346957101db9ce"
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp" => :test

  def install
    system "cmake", " -S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <valijson/schema.hpp>
      #include <valijson/adapters/jsoncpp_adapter.hpp>
      #include <valijson/utils/jsoncpp_utils.hpp>

      int main (void) { std::cout << "Hello world"; }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-L#{Formula["jsoncpp"].opt_lib}", "-ljsoncpp", "-o", "test"
    system "./test"
  end
end
