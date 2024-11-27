class ClangUml < Formula
  desc "Customizable automatic UML diagram generator for C++ based on Clang"
  homepage "https://github.com/bkryza/clang-uml"
  url "https://mirror.ghproxy.com/https://github.com/bkryza/clang-uml/archive/refs/tags/0.5.6.tar.gz"
  sha256 "7a92e7b8b4f1d269087f13e05ea7ff2ae3f2ca0a8e3ecd0a4db34444bb8dc4f9"
  license "Apache-2.0"
  head "https://github.com/bkryza/clang-uml.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "e8527b07cfad9e26e73127631eadeadc661d183c6cdb03ff3405244df225f0ef"
    sha256 cellar: :any,                 arm64_sonoma:  "ac3003dac9ef3014ebc2649d9ba455fdfbd76c8778c1dec13bfe59ebf6e973ac"
    sha256 cellar: :any,                 arm64_ventura: "b0f65d8510f0a0685972cdd5404165969e743d1782dbfd751d5e29d2fb4ffbb9"
    sha256 cellar: :any,                 sonoma:        "75a3ad5215b45b54bb74e8646419aaa1ae63a649d43f9bc29d991431edb74b00"
    sha256 cellar: :any,                 ventura:       "c300dafc9f8abe3422ae79b528277dff1de15c1b62dd6e01ede7ef98637cc3e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a31c7e482ce458b220713abb0e0e5ffd71ca6c829dbd7cb118da6df567e2e16"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "pkgconf" => :build
  depends_on "llvm"
  depends_on "yaml-cpp"

  def llvm
    deps.map(&:to_formula)
        .find { |f| f.name.match?(/^llvm(@\d+)?$/) }
  end

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath(target: llvm.opt_lib)}" if OS.linux? && llvm.versioned_formula?
    args = %w[
      -DBUILD_TESTS=OFF
    ]

    # If '.git' directory is not available during build, we need
    # to provide the version using a CMake option
    args << "-DGIT_VERSION=#{version}" if build.stable?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    bash_completion.install "packaging/autocomplete/clang-uml"
    zsh_completion.install "packaging/autocomplete/_clang-uml"
  end

  test do
    # Check if clang-uml is linked properly
    system bin/"clang-uml", "--version"
    system bin/"clang-uml", "--help"

    # Initialize a minimal C++ CMake project and try to generate a
    # PlantUML diagram from it
    (testpath/"test.cc").write <<~CPP
      #include <stddef.h>
      namespace A {
        struct AA { size_t s; };
      }
      int main(int argc, char** argv) { A::AA a; return 0; }
    CPP
    (testpath/".clang-uml").write <<~YAML
      compilation_database_dir: build
      output_directory: diagrams
      diagrams:
        test_class:
          type: class
          include:
            namespaces:
              - A
    YAML
    (testpath/"CMakeLists.txt").write <<~CMAKE
      cmake_minimum_required(VERSION 3.15)

      project(clang-uml-test CXX)

      set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

      add_executable(clang-uml-test test.cc)
    CMAKE

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args

    system bin/"clang-uml", "--no-metadata", "--query-driver", "."

    expected_output = Regexp.new(<<~EOS, Regexp::MULTILINE)
      @startuml
      class "A::AA" as C_\\d+
      class C_\\d+ {
      __
      \\+s : size_t
      }
      @enduml
    EOS

    assert_predicate testpath/"diagrams"/"test_class.puml", :exist?

    assert_match expected_output, (testpath/"diagrams/test_class.puml").read
  end
end
