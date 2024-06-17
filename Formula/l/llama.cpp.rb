class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3158",
      revision: "52399254b3bceda279b4ea9111a983e32310166e"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9f769d1ad20c8a0eac7ca45ecdc735204d9301779383378be3f0a1e0258428ea"
    sha256 cellar: :any,                 arm64_ventura:  "a45ed9d24fc3786c76f0e7a720937e3c31b35e6cc0befd50859bc43a48bb05c2"
    sha256 cellar: :any,                 arm64_monterey: "8ecc514ef0f9a9ae03560cca8e09dcb873914f0d4650a38514b0ea0d383418d1"
    sha256 cellar: :any,                 sonoma:         "cc9d37ff959740a5dc134b2f705fa6b9845d4efaae4911de482f70036c7c2fd1"
    sha256 cellar: :any,                 ventura:        "ad19e7840641e20bd86dce0252f5e85228a6f0b7e4469af273a8eb60cc52f62d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56da868a2e2634d03b95f6e9a4e74d12c8504d4273715220e6bb560c8e9b7bb3"
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
