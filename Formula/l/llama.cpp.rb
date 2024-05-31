class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3046",
      revision: "9c4c9cc83f7297a10bb3b2af54a22ac154fd5b20"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0ba8daafc5c149e6d55324639193ee1f213419875ab2f173024b27eebdac3a83"
    sha256 cellar: :any,                 arm64_ventura:  "eb18327ff4d18a605a91995aa39cbadafe98caa0e86047247610711345ecc244"
    sha256 cellar: :any,                 arm64_monterey: "76eab894847fe62023166c9511af09456d5d12ef8b592d405aac2e22604613e6"
    sha256 cellar: :any,                 sonoma:         "2ee8a414bf74ff0385e67d7f767d73ee8bb0fd66ff3091ae38b970cd02d67660"
    sha256 cellar: :any,                 ventura:        "7804d24ee81f644990d6c660fcd03327b140133e16742eb9d45a8161261523e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2a0c7968aed6905c63af93fd0395374fb978c1c6edb0cf34b86686337247d8d"
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
