class Coin3d < Formula
  desc "Open Inventor 2.1 API implementation (Coin) with Python bindings (Pivy)"
  homepage "https://coin3d.github.io/"
  license all_of: ["BSD-3-Clause", "ISC"]

  stable do
    url "https://mirror.ghproxy.com/https://github.com/coin3d/coin/releases/download/v4.0.1/coin-4.0.1-src.zip"
    sha256 "267f36baa2bece32445fb1879f7a1c7931bd3a274affa04660d36a262370fdf2"

    # TODO: migrate pyside@2 -> pyside and python@3.10 -> python@3.12 on next pivy release
    resource "pivy" do
      url "https://mirror.ghproxy.com/https://github.com/coin3d/pivy/archive/refs/tags/0.6.8.tar.gz"
      sha256 "c443dd7dd724b0bfa06427478b9d24d31e0c3b5138ac5741a2917a443b28f346"
    end
  end

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "3ad22a7dd39a9e022049878282fb976dedbcfe98681ce03b09476961326950d8"
    sha256 cellar: :any, arm64_ventura:  "0024daf187ebcb36e6d4fa26b04fca49a25f0798e50912cef8d4bac1de43cf25"
    sha256 cellar: :any, arm64_monterey: "9277d0d51f9904bf5d2022b0b08c93ab7ca6c559e02e21a3bdbe7a6a47418f5d"
    sha256 cellar: :any, sonoma:         "966357de8e031f3ce234d2fc973b0875a5ea9ff27cb87ab79ccfcefe43d2bb2e"
    sha256 cellar: :any, ventura:        "e492d9afcdf9254176491b4484056aa1bded811eb4bf4fe88dd0ab8ee8f7b10d"
    sha256 cellar: :any, monterey:       "388c68347ed11a681f42624a06e90e20dd09c280ddf64d1544fb5b5b31184d9d"
  end

  head do
    url "https://github.com/coin3d/coin.git", branch: "master"

    resource "pivy" do
      url "https://github.com/coin3d/pivy.git", branch: "master"
    end
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "ninja" => :build
  depends_on "swig" => :build
  depends_on "boost"
  depends_on "pyside@2"
  depends_on "python@3.10"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  def python3
    "python3.10"
  end

  def install
    system "cmake", "-S", ".", "-B", "_build",
                    "-DCOIN_BUILD_MAC_FRAMEWORK=OFF",
                    "-DCOIN_BUILD_DOCUMENTATION=ON",
                    "-DCOIN_BUILD_TESTS=OFF",
                    *std_cmake_args
    system "cmake", "--build", "_build"
    system "cmake", "--install", "_build"

    resource("pivy").stage do
      ENV.append_path "CMAKE_PREFIX_PATH", prefix.to_s
      ENV["LDFLAGS"] = "-Wl,-rpath,#{opt_lib}"
      system python3, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <Inventor/SoDB.h>
      int main() {
        SoDB::init();
        SoDB::cleanup();
        return 0;
      }
    EOS

    opengl_flags = if OS.mac?
      ["-Wl,-framework,OpenGL"]
    else
      ["-L#{Formula["mesa"].opt_lib}", "-lGL"]
    end

    system ENV.cc, "test.cpp", "-L#{lib}", "-lCoin", *opengl_flags, "-o", "test"
    system "./test"

    ENV.append_path "PYTHONPATH", Formula["pyside@2"].opt_prefix/Language::Python.site_packages(python3)
    # Set QT_QPA_PLATFORM to minimal to avoid error:
    # "This application failed to start because no Qt platform plugin could be initialized."
    ENV["QT_QPA_PLATFORM"] = "minimal" if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
    system python3, "-c", <<~EOS
      import shiboken2
      from pivy.sogui import SoGui
      assert SoGui.init("test") is not None
    EOS
  end
end
