class Fifechan < Formula
  desc "C++ GUI library designed for games"
  homepage "https://fifengine.github.io/fifechan/"
  url "https://mirror.ghproxy.com/https://github.com/fifengine/fifechan/archive/refs/tags/0.1.5.tar.gz"
  sha256 "29be5ff4b379e2fc4f88ef7d8bc172342130dd3e77a3061f64c8a75efe4eba73"
  license "LGPL-2.1-or-later"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia:  "71f641735c72610a5de0482f15c41098d817fed78afcebc8c4c41a686505cb7b"
    sha256 cellar: :any,                 arm64_sonoma:   "277fbd536c176f738c60124aea4321ec581e32491ee82fc13dceec867574705b"
    sha256 cellar: :any,                 arm64_ventura:  "a8deaa164106ac1b37cc156fc4707b8517b07194cf87adc348094600dfbd40b6"
    sha256 cellar: :any,                 arm64_monterey: "462d21b6d9e655b260847f1aace8c011f07145d335aaaf1984c09fbfc2712699"
    sha256 cellar: :any,                 arm64_big_sur:  "73f4cff07f6b17373b6c3c94734aa26de09a5cf6c9ec25e92b35d66c605ba728"
    sha256 cellar: :any,                 sonoma:         "bbe357a25dcc2699f8b5475ce9355efa7ed125edc030dccda7830fce8d337bd7"
    sha256 cellar: :any,                 ventura:        "f10339a3a2211ec705b3d57306dcd884b13a921d96806c2b47fed05cb68efe41"
    sha256 cellar: :any,                 monterey:       "d1bbc100bb520395b6298b89ac2b71b48cdfc7df30e526177340b0fec4b58500"
    sha256 cellar: :any,                 big_sur:        "9803b9f51bc0c0d368baaf0dfcf1bd1694426b1ed0fee2e247835b49fa62f3ec"
    sha256 cellar: :any,                 catalina:       "c0594d877411b0a33f2a37d0d3e2ca38a3d3dfd47797bf89aef9579bd2095dda"
    sha256 cellar: :any,                 mojave:         "93491cce22fd712b86ec6f7af129107a596f2e736181354417c4d48c0c40b919"
    sha256 cellar: :any,                 high_sierra:    "725c25c62dd609dd58d19c25b484398e9e68f19a9cb7aa3c1d1877b53ed9615a"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "7150b47d24b6dbfa2fb82f3c0be8c976f029e98980d03d6826134ae22fe41d0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74a7a968d5242dfdcf05c0c35bd360770f87afe32adc6dbacb2850ff117f6d5a"
  end

  depends_on "cmake" => :build

  depends_on "allegro"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_ttf"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DENABLE_SDL_CONTRIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"fifechan_test.cpp").write <<~CPP
      #include <fifechan.hpp>
      int main(int n, char** c) {
        fcn::Container* mContainer = new fcn::Container();
        if (mContainer == nullptr) {
          return 1;
        }
        return 0;
      }
    CPP

    system ENV.cxx, "fifechan_test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lfifechan", "-o", "fifechan_test"
    system "./fifechan_test"
  end
end
