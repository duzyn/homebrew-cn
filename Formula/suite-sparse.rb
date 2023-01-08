class SuiteSparse < Formula
  desc "Suite of Sparse Matrix Software"
  homepage "https://people.engr.tamu.edu/davis/suitesparse.html"
  url "https://github.com/DrTimothyAldenDavis/SuiteSparse/archive/v6.0.3.tar.gz"
  sha256 "7111b505c1207f6f4bd0be9740d0b2897e1146b845d73787df07901b4f5c1fb7"
  license all_of: [
    "BSD-3-Clause",
    "LGPL-2.1-or-later",
    "GPL-2.0-or-later",
    "Apache-2.0",
    "GPL-3.0-only",
    any_of: ["LGPL-3.0-or-later", "GPL-2.0-or-later"],
  ]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b19d379787b225266f4ac0d8844099f6abc2e619419d15052ca401247dd52a83"
    sha256 cellar: :any,                 arm64_monterey: "e2337bd5db3169e5c2b5b4bd869046f3ab2a2a45deae9bb5c4f016b105183227"
    sha256 cellar: :any,                 arm64_big_sur:  "9a7a4daf35874c2eb86b106730b74add2d82ab5b25759a2a3a25dd8a5f3f9ace"
    sha256 cellar: :any,                 ventura:        "78a06034ae76cfc508e3e28a1d4536b00425d234b615434029f442c4b55d2211"
    sha256 cellar: :any,                 monterey:       "55bff923c3d4fc50851ebbed8117120ca4d0fad57804d246dd275c405f69329e"
    sha256 cellar: :any,                 big_sur:        "7db60d709ecfc631b19ee164196dc1174c726b0a35184373b3ceb4862d3e6acc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b74e86097e8da7b3fb661776a97b0c116a6ed4c281a70476e2341a51f8cfbfa"
  end

  depends_on "cmake" => :build
  depends_on "metis"
  depends_on "openblas"

  uses_from_macos "m4"

  conflicts_with "mongoose", because: "suite-sparse vendors libmongoose.dylib"

  def install
    cmake_args = *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    args = [
      "INSTALL=#{prefix}",
      "BLAS=-L#{Formula["openblas"].opt_lib} -lopenblas",
      "LAPACK=$(BLAS)",
      "MY_METIS_LIB=-L#{Formula["metis"].opt_lib} -lmetis",
      "MY_METIS_INC=#{Formula["metis"].opt_include}",
      "CMAKE_OPTIONS=#{cmake_args.join(" ")}",
      "JOBS=#{ENV.make_jobs}",
    ]

    # Parallelism is managed through the `JOBS` make variable and not with `-j`.
    ENV.deparallelize
    system "make", "library", *args
    system "make", "install", *args
    lib.install Dir["**/*.a"]
    pkgshare.install "KLU/Demo/klu_simple.c"
  end

  test do
    system ENV.cc, "-o", "test", pkgshare/"klu_simple.c",
           "-L#{lib}", "-lsuitesparseconfig", "-lklu"
    assert_predicate testpath/"test", :exist?
    assert_match "x [0] = 1", shell_output("./test")
  end
end
