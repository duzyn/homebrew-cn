class CmakeDocs < Formula
  desc "Documentation for CMake"
  homepage "https://www.cmake.org/"
  url "https://mirror.ghproxy.com/https://github.com/Kitware/CMake/releases/download/v3.31.3/cmake-3.31.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/cmake-3.31.3.tar.gz"
  mirror "http://fresh-center.net/linux/misc/legacy/cmake-3.31.3.tar.gz"
  sha256 "fac45bc6d410b49b3113ab866074888d6c9e9dc81a141874446eb239ac38cb87"
  license "BSD-3-Clause"
  head "https://gitlab.kitware.com/cmake/cmake.git", branch: "master"

  livecheck do
    formula "cmake"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e918e8a3d4fb923ebd5585428734df468c1932cef85f3a4794005308e719a23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e918e8a3d4fb923ebd5585428734df468c1932cef85f3a4794005308e719a23"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6e918e8a3d4fb923ebd5585428734df468c1932cef85f3a4794005308e719a23"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc7d4ab8d30dfcc5af83ab34e2df1f16fea63fe5b9e84357325804af80427444"
    sha256 cellar: :any_skip_relocation, ventura:       "fc7d4ab8d30dfcc5af83ab34e2df1f16fea63fe5b9e84357325804af80427444"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e918e8a3d4fb923ebd5585428734df468c1932cef85f3a4794005308e719a23"
  end

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build

  def install
    system "cmake", "-S", "Utilities/Sphinx", "-B", "build", *std_cmake_args,
                                                             "-DCMAKE_DOC_DIR=share/doc/cmake",
                                                             "-DCMAKE_MAN_DIR=share/man",
                                                             "-DSPHINX_MAN=ON",
                                                             "-DSPHINX_HTML=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_path_exists share/"doc/cmake/html"
    assert_path_exists man
  end
end
