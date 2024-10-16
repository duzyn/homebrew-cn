class Fatal < Formula
  desc "Facebook Template Library"
  homepage "https://www.facebook.com/groups/libfatal/"
  url "https://mirror.ghproxy.com/https://github.com/facebook/fatal/releases/download/v2024.10.14.00/fatal-v2024.10.14.00.tar.gz"
  sha256 "4350a2923dba48f65ba5b6ff7c3e8c7319015d2c052a335c25ecd7b821124a29"
  license "BSD-3-Clause"
  head "https://github.com/facebook/fatal.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "caf4626e3f30c7a57d46939c4ca6297ec7ca99ae558f2bb5398ee594b68bb2d4"
  end

  def install
    rm "fatal/.clang-tidy"
    include.install "fatal"
    pkgshare.install "demo", "lesson", *buildpath.glob("*.sh")
    inreplace "README.md" do |s|
      s.gsub!("(lesson/)", "(share/fatal/lesson/)")
      s.gsub!("(demo/)", "(share/fatal/demo/)")
    end
  end

  test do
    system ENV.cxx, "-std=c++14", "-I#{include}",
                    include/"fatal/benchmark/test/benchmark_test.cpp",
                    "-o", "benchmark_test"
    system "./benchmark_test"
  end
end
