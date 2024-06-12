class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3130",
      revision: "4bfe50f741479c1df1c377260c3ff5702586719e"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "349172fcdfb9259e5fd4c87387e34fb896eb4fcff0ac8c8eeceb21f8a7cffbe0"
    sha256 cellar: :any,                 arm64_ventura:  "31ddfcc0002e98714396ca882bc8a143751fabd410c40db954edccf65e4f0986"
    sha256 cellar: :any,                 arm64_monterey: "52232440a146d505f36aebe989ff19ec073513bd6f81f9f564c252b842417446"
    sha256 cellar: :any,                 sonoma:         "7734df31e19a69d5ae30ed1d304aaa88f3d37feb471070c94bfa4265dfa9c72c"
    sha256 cellar: :any,                 ventura:        "ad5fabbb6e9734e7d57b11d4300f012d7d0bc97424716437dd78d94ccb1487b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0985998db249d7a7f67b44f8a0ccaca7c1af1ce663c4e73c4cd8fa0d88606cb9"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "openblas"
  end

  def install
    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DLLAMA_LTO=ON
      -DLLAMA_CCACHE=OFF
      -DLLAMA_ALL_WARNINGS=OFF
      -DLLAMA_NATIVE=#{build.bottle? ? "OFF" : "ON"}
      -DLLAMA_ACCELLERATE=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_BLAS=#{OS.linux? ? "ON" : "OFF"}
      -DLLAMA_BLAS_VENDOR=OpenBLAS
      -DLLAMA_METAL=#{OS.mac? ? "ON" : "OFF"}
      -DLLAMA_METAL_EMBED_LIBRARY=ON
      -DLLAMA_CURL=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]
    args << "-DLLAMA_METAL_MACOSX_VERSION_MIN=#{MacOS.version}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install bin.children
    libexec.children.each do |file|
      next unless file.executable?

      new_name = if file.basename.to_s == "main"
        "llama"
      else
        "llama-#{file.basename}"
      end

      bin.install_symlink file => new_name
    end
  end

  test do
    system bin/"llama", "--hf-repo", "ggml-org/tiny-llamas",
                        "-m", "stories260K.gguf",
                        "-n", "400", "-p", "I", "-ngl", "0"
  end
end
