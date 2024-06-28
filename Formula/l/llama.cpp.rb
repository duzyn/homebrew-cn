class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3248",
      revision: "f675b20a3b7f878bf3be766b9a737e2c8321ff0d"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8fc4c9a9a8c118309968dc44efce40976b1d0620998bdf3a2bc32a6f18c61e6f"
    sha256 cellar: :any,                 arm64_ventura:  "933ba0a13f5fb1dc123731e8630c275fc28a5921cec5cb3076bc8947c5551f82"
    sha256 cellar: :any,                 arm64_monterey: "7f637818d8b8ce6fb90ba9a4f488a8b780b20f171126a6d3e8d3ed216a48a114"
    sha256 cellar: :any,                 sonoma:         "f687fdc22d79da8e124597e149e933fd74fcfb5d3d07129c4431aa56adce2136"
    sha256 cellar: :any,                 ventura:        "f8bf88cafbfc6f1c6bab5855f42e729fe185fa266edf4fc4a8875c550348b192"
    sha256 cellar: :any,                 monterey:       "82976d43136cdb9abe830ca93b7e545c9772f3bb7ef94e2e547bbee14887ec55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75a118eae42c28e88ba3d08f660c07324299b246d2a99ac084da614c5ba52df6"
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
