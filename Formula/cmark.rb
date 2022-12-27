class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.30.2.tar.gz"
  sha256 "6c7d2bcaea1433d977d8fed0b55b71c9d045a7cdf616e3cd2dce9007da753db3"
  license "BSD-2-Clause"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "bfa1d758eb00bf9693f42cb010065ff0154d99ecc9f54933db7d633d1a413860"
    sha256 cellar: :any,                 arm64_monterey: "422041e7f5634ac51994edb5f7313782ad1de31b707b55eb6cf042a2a6020b02"
    sha256 cellar: :any,                 arm64_big_sur:  "9b5b1fe680848c5c2daa8f6f636c4d926fffa87487003b30b1654f21459c12f1"
    sha256 cellar: :any,                 ventura:        "aeba72c89d42c0f92b57054b0cb729830b9f04c544b6fc7ceef6a8074fc1adab"
    sha256 cellar: :any,                 monterey:       "7844d321c93675aea242f5e1dc7c0e7c35c1970a3e9e0a8c3dbe0d36ae005a1c"
    sha256 cellar: :any,                 big_sur:        "a62222cbcb8e767902d0be715b8dd43fd0b5588d1a8967a08276eb0ad116f0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef97bf27186db785e00914f19fff87648efac9dc573a53e6a68a8e900b5c6a1c"
  end

  depends_on "cmake" => :build
  depends_on "python@3.11" => :build

  conflicts_with "cmark-gfm", because: "both install a `cmark.h` header"

  def install
    mkdir "build" do
      system "cmake", "..", "-DCMAKE_INSTALL_LIBDIR=lib", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
