class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3223",
      revision: "49c03c79cda17913b72260acdc8157b742cee41c"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "44eca293f31827f1c47dbf8bf1910f5f724314e2e6145fe610d8feca5d9dc5b7"
    sha256 cellar: :any,                 arm64_ventura:  "fed8e84f264acaae82acb854e05ef8d3ce379cf827fe806272c18e356343fe2b"
    sha256 cellar: :any,                 arm64_monterey: "3f76319e79f35900e15dc5b66e1b250f8d1540aa065551a678f32ba43e4cb4be"
    sha256 cellar: :any,                 sonoma:         "2f23685d37be71a29714f5db26e2b79f1bd31af11931a6d74b5749b38b41603d"
    sha256 cellar: :any,                 ventura:        "df8d7db3fc2f90a9c89028b41635b24984bd1a44ec967541d6fe2de74da0699a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3b43c6af9fbf665c70b2ba131c4261ba5a9122f6118eb153f43a3f3f0e6a3dd"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  on_linux do
    depends_on "pkg-config" => :build
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
    bin.install_symlink libexec.children.select { |file|
                          file.executable? && !file.basename.to_s.start_with?("test-")
                        }
  end

  test do
    system bin/"llama-cli", "--hf-repo", "ggml-org/tiny-llamas",
                            "-m", "stories260K.gguf",
                            "-n", "400", "-p", "I", "-ngl", "0"
  end
end
