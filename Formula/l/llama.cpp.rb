class LlamaCpp < Formula
  desc "LLM inference in C/C++"
  homepage "https://github.com/ggerganov/llama.cpp"
  # CMake uses Git to generate version information.
  url "https://github.com/ggerganov/llama.cpp.git",
      tag:      "b3206",
      revision: "11318d9aa1f668aa10407a5cb9614371af32f3ce"
  license "MIT"
  head "https://github.com/ggerganov/llama.cpp.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?b(\d+(?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ffd0f2b9ec0f0ab7f0c152d5b3323413cd42dce37a1534851a5c4fe6d756ebcf"
    sha256 cellar: :any,                 arm64_ventura:  "3fbaea0f5e08d6891a78ff582cc0bb844d63e69a7ad3c68d0513978023b95f68"
    sha256 cellar: :any,                 arm64_monterey: "3265513f5b052f32c00f90a3eae21c2a34ea54b421e393ace5b084d5b2d35155"
    sha256 cellar: :any,                 sonoma:         "ec1137198fb0249b21cb4e7a0647c8c658173978fb774927435f4f6bd3d21c29"
    sha256 cellar: :any,                 ventura:        "512689b8dd691bbf357580f5c95383e0b4123191e5f32bd212ba7e9ad4803e27"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aee6dd0b147a5634c2f1ff25357f2c3ed5cdab15f8017452b208d1a4b316747"
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
