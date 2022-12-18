class SwiProlog < Formula
  desc "ISO/Edinburgh-style Prolog interpreter"
  homepage "https://www.swi-prolog.org/"
  url "https://www.swi-prolog.org/download/stable/src/swipl-9.0.2.tar.gz"
  sha256 "33b5de34712d58f14c1e019bd1613df9a474f5e5fd024155a0f6e67ebb01c307"
  license "BSD-2-Clause"
  head "https://github.com/SWI-Prolog/swipl-devel.git", branch: "master"

  livecheck do
    url "https://www.swi-prolog.org/download/stable/src/"
    regex(/href=.*?swipl[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1cc32faa27bb1c02936d37d49adc58be62875e7ec8baa4951892aed260980836"
    sha256 arm64_monterey: "e0c23800c4cc715e24ef922d114c69b63eb06c91a4b2554145c79de3d19a6aba"
    sha256 arm64_big_sur:  "49284384aad776c9a4a6d7edb865b3c7bb126b5f7a9ed79c639a02ff44bc0e04"
    sha256 ventura:        "a8348ee2ecd50798953e7c5a69d2980362d76a7c4f93a8323161184964775dbf"
    sha256 monterey:       "4c9da59192f8dc392146520c8b45833e2afbabccddcf1e4f8b8dc054f0c0e2f5"
    sha256 big_sur:        "ffc5e044ef693e2eae4900d85816a9646f5df6058d8dc97e93835f8bc0e30303"
    sha256 x86_64_linux:   "f0fcf9d10f8bd96df32886daf7c79e7a949074f9c206caddd7e2a179919f04c9"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "gmp"
  depends_on "libarchive"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "pcre"
  depends_on "readline"
  depends_on "unixodbc"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  def install
    # Remove shim paths from binary files `swipl-ld` and `libswipl.so.*`
    if OS.linux?
      inreplace "cmake/Params.cmake" do |s|
        s.gsub! "${CMAKE_C_COMPILER}", "\"gcc\""
        s.gsub! "${CMAKE_CXX_COMPILER}", "\"g++\""
      end
    end

    args = ["-DSWIPL_PACKAGES_JAVA=OFF", "-DSWIPL_PACKAGES_X=OFF", "-DCMAKE_INSTALL_RPATH=#{loader_path}"]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args(install_prefix: libexec)
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bin.write_exec_script (libexec/"bin").children
  end

  test do
    (testpath/"test.pl").write <<~EOS
      test :-
          write('Homebrew').
    EOS
    assert_equal "Homebrew", shell_output("#{bin}/swipl -s #{testpath}/test.pl -g test -t halt")
  end
end
