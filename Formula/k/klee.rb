class Klee < Formula
  include Language::Python::Shebang
  include Language::Python::Virtualenv

  desc "Symbolic Execution Engine"
  homepage "https://klee-se.org"
  url "https://mirror.ghproxy.com/https://github.com/klee/klee/archive/refs/tags/v3.1.tar.gz"
  sha256 "ae3d97209fa480ce6498ffaa7eaa7ecbbe22748c739cb7b2389391d0d9c940f7"
  license "NCSA"
  revision 1
  head "https://github.com/klee/klee.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_sequoia: "262a3321fd86fffaa6272a26fae9ffccde49bda2285893d31370347522abc8c4"
    sha256 arm64_sonoma:  "b6afa2ba09a0726ddfea174a3a2662f9de112c1c4fc717a3499ad4d7b040a3c1"
    sha256 arm64_ventura: "7add7340e6771b415d2144a610c175530e2f65ec3bd64533b763be1f7ea931ea"
    sha256 sonoma:        "7de8d29c9fa862bac0789f3a37073df7921f3c3498efbab9ddc0299dfffab371"
    sha256 ventura:       "295c6e0c2e66ec6d30ab71526ccb44e2f667decb1ac0c187fde988c617a1587f"
    sha256 x86_64_linux:  "f18180b6872624ad20c474f8d998c942fefa20a3bde2bf5a01cff48b61f451d3"
  end

  depends_on "cmake" => :build

  depends_on "gperftools"
  depends_on "llvm@16"
  depends_on "python@3.12"
  depends_on "sqlite"
  depends_on "stp"
  depends_on "wllvm"
  depends_on "z3"

  uses_from_macos "zlib"

  on_macos do
    depends_on "cryptominisat"
    depends_on "minisat"
  end

  fails_with gcc: "5"

  # klee needs a version of libc++ compiled with wllvm
  resource "libcxx" do
    url "https://mirror.ghproxy.com/https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.6/llvm-project-16.0.6.src.tar.xz"
    sha256 "ce5e71081d17ce9e86d7cbcfa28c4b04b9300f8fb7e78422b1feb6bc52c3028e"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match? "^llvm" }
  end

  def install
    libcxx_install_dir = libexec/"libcxx"
    libcxx_src_dir = buildpath/"libcxx"
    resource("libcxx").stage libcxx_src_dir

    # Use build configuration at
    # https://github.com/klee/klee/blob/v#{version}/scripts/build/p-libcxx.inc
    libcxx_args = std_cmake_args(install_prefix: libcxx_install_dir) + %W[
      -DRUNTIMES_CMAKE_ARGS=-DCMAKE_INSTALL_RPATH=#{rpath}
      -DLLVM_ENABLE_RUNTIMES=libcxx;libcxxabi
      -DLLVM_ENABLE_PROJECTS=
      -DLLVM_ENABLE_PROJECTS_USED:BOOL=ON
      -DLLVM_ENABLE_THREADS:BOOL=OFF
      -DLLVM_ENABLE_EH:BOOL=OFF
      -DLLVM_ENABLE_RTTI:BOOL=OFF
      -DLIBCXX_ENABLE_THREADS:BOOL=OFF
      -DLIBCXX_ENABLE_SHARED:BOOL=ON
      -DLIBCXX_ENABLE_STATIC_ABI_LIBRARY:BOOL=#{OS.mac? ? "OFF" : "ON"}
      -DLIBCXXABI_ENABLE_THREADS:BOOL=OFF
    ]

    with_env(
      CC:                 "wllvm",
      CXX:                "wllvm++",
      LLVM_COMPILER:      "clang",
      LLVM_COMPILER_PATH: llvm.opt_bin,
    ) do
      system "cmake", "-S", libcxx_src_dir/"llvm", "-B", "libcxx_build", *libcxx_args
      system "cmake", "--build", "libcxx_build", "--target", "runtimes"
      system "cmake", "--install", "libcxx_build/runtimes"
    end

    libcxx_libs = libcxx_install_dir.glob("lib/{#{shared_library("*")},*.a}").reject(&:symlink?)
    libcxx_libs.each { |sl| system "extract-bc", sl }

    # Avoid building 32-bit runtime
    inreplace "CMakeLists.txt", "M32_SUPPORTED 1", "M32_SUPPORTED 0"

    # CMake options are documented at
    # https://github.com/klee/klee/blob/v#{version}/README-CMake.md
    args = %W[
      -DKLEE_RUNTIME_BUILD_TYPE=Release
      -DKLEE_LIBCXX_DIR=#{libcxx_install_dir}
      -DKLEE_LIBCXX_BC_PATH=#{libcxx_install_dir}/lib
      -DKLEE_LIBCXX_INCLUDE_DIR=#{libcxx_install_dir}/include
      -DKLEE_LIBCXX_INCLUDE_PATH=#{libcxx_install_dir}/include/c++/v1
      -DKLEE_LIBCXXABI_SRC_DIR=#{libcxx_src_dir}/libcxxabi
      -DLLVM_CONFIG_BINARY=#{llvm.opt_bin}/llvm-config
      -DM32_SUPPORTED=OFF
      -DENABLE_KLEE_ASSERTS=ON
      -DENABLE_KLEE_LIBCXX=ON
      -DENABLE_SOLVER_STP=ON
      -DENABLE_TCMALLOC=ON
      -DENABLE_SOLVER_Z3=ON
      -DENABLE_ZLIB=ON
      -DENABLE_DOCS=OFF
      -DENABLE_SYSTEM_TESTS=OFF
      -DENABLE_KLEE_EH_CXX=OFF
      -DENABLE_KLEE_UCLIBC=OFF
      -DENABLE_POSIX_RUNTIME=OFF
      -DENABLE_SOLVER_METASMT=OFF
      -DENABLE_UNIT_TESTS=OFF
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    venv = virtualenv_create(libexec/"venv", "python3.12")
    venv.pip_install resource("tabulate")
    rewrite_shebang python_shebang_rewrite_info(venv.root/"bin/python"), *bin.children
  end

  # Test adapted from
  # http://klee.github.io/tutorials/testing-function/
  test do
    (testpath/"get_sign.c").write <<~EOS
      #include "klee/klee.h"

      int get_sign(int x) {
        if (x == 0)
          return 0;
        if (x < 0)
          return -1;
        else
          return 1;
      }

      int main() {
        int a;
        klee_make_symbolic(&a, sizeof(a), "a");
        return get_sign(a);
      }
    EOS

    ENV["CC"] = llvm.opt_bin/"clang"

    system ENV.cc, "-I#{opt_include}", "-emit-llvm",
                    "-c", "-g", "-O0", "-Xclang", "-disable-O0-optnone",
                    testpath/"get_sign.c"

    total_instructions = 32
    expected_output = <<~EOS
      KLEE: done: total instructions = #{total_instructions}
      KLEE: done: completed paths = 3
      KLEE: done: partially completed paths = 0
      KLEE: done: generated tests = 3
    EOS
    assert_match expected_output, shell_output("#{bin}/klee get_sign.bc 2>&1")
    assert_predicate testpath/"klee-out-0", :exist?

    assert_match "['get_sign.bc']", shell_output("#{bin}/ktest-tool klee-last/test000001.ktest")

    system ENV.cc, "-I#{opt_include}", "-L#{opt_lib}", "-lkleeRuntest", testpath/"get_sign.c"
    with_env(KTEST_FILE: "klee-last/test000001.ktest") do
      system "./a.out"
    end

    assert_match <<~EOS, shell_output("#{bin}/klee-stats --print-columns='Instrs' --table-format=csv klee-out-0")
      Instrs
      #{total_instructions}
    EOS
  end
end
