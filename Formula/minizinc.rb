class Minizinc < Formula
  desc "Medium-level constraint modeling language"
  homepage "https://www.minizinc.org/"
  url "https://github.com/MiniZinc/libminizinc/archive/2.6.4.tar.gz"
  sha256 "f1f5adba23c749ddfdb2420e797d7ff46e72b843850529978f867583dbc599ca"
  license "MPL-2.0"
  revision 1
  head "https://github.com/MiniZinc/libminizinc.git", branch: "develop"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8ecf20964c1bb16869a8b3def93e4c58f1fada50f0a4c67d3e94c5d6e41651d8"
    sha256 cellar: :any,                 arm64_monterey: "e667adcf77e2bbff8d970ec2910a069056883fd84bfb5e2a6d9fc03fb427e00d"
    sha256 cellar: :any,                 arm64_big_sur:  "0896b3d82fd6c45026a8a0a1219f5131788a674d8813e477132f6ca4acf604e5"
    sha256 cellar: :any,                 ventura:        "bbe98cdaf64fe39ec2e437d888b484c327bed1b57c4d8c19cb0dac012e3de88f"
    sha256 cellar: :any,                 monterey:       "0b4f40579810053ec46b3dcbc6650b94ebfadc6b308c20b12e0c4915d5ff7ce6"
    sha256 cellar: :any,                 big_sur:        "ddb4bb3b4b276f54ff8d499453f3a9066520ed0e33613df6496ec125200b0729"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7be4e8677937f67b7a309377e3a988ac17dd9d0c407e335d333cf17da1d0948"
  end

  depends_on "cmake" => :build
  depends_on "cbc"
  depends_on "gecode"

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"satisfy.mzn").write <<~EOS
      array[1..2] of var bool: x;
      constraint x[1] xor x[2];
      solve satisfy;
    EOS
    assert_match "----------", shell_output("#{bin}/minizinc --solver gecode_presolver satisfy.mzn").strip

    (testpath/"optimise.mzn").write <<~EOS
      array[1..2] of var 1..3: x;
      constraint x[1] < x[2];
      solve maximize sum(x);
    EOS
    assert_match "==========", shell_output("#{bin}/minizinc --solver cbc optimise.mzn").strip
  end
end
