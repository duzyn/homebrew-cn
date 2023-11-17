class Xtensor < Formula
  desc "Multi-dimensional arrays with broadcasting and lazy computing"
  homepage "https://xtensor.readthedocs.io/en/latest/"
  url "https://mirror.ghproxy.com/https://github.com/xtensor-stack/xtensor/archive/refs/tags/0.24.7.tar.gz"
  sha256 "0fbbd524dde2199b731b6af99b16063780de6cf1d0d6cb1f3f4d4ceb318f3106"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a91111d6567d75261737e3a1d0d3d77509b54312250ef13097adede678b816e"
  end

  depends_on "cmake" => :build

  resource "xtl" do
    url "https://mirror.ghproxy.com/https://github.com/xtensor-stack/xtl/archive/refs/tags/0.7.5.tar.gz"
    sha256 "3286fef5fee5d58f82f7b91375cd449c819848584bae9367893501114d923cbe"
  end

  def install
    resource("xtl").stage do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end

    system "cmake", ".", "-Dxtl_DIR=#{lib}/cmake/xtl", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <iostream>
      #include "xtensor/xarray.hpp"
      #include "xtensor/xio.hpp"
      #include "xtensor/xview.hpp"

      int main() {
        xt::xarray<double> arr1
          {{11.0, 12.0, 13.0},
           {21.0, 22.0, 23.0},
           {31.0, 32.0, 33.0}};

        xt::xarray<double> arr2
          {100.0, 200.0, 300.0};

        xt::xarray<double> res = xt::view(arr1, 1) + arr2;

        std::cout << res(2) << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-o", "test", "-I#{include}"
    assert_equal "323", shell_output("./test").chomp
  end
end
