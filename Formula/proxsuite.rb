class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghproxy.com/github.com/Simple-Robotics/proxsuite/releases/download/v0.2.16/proxsuite-0.2.16.tar.gz"
  sha256 "02380c3da3169ca147d8f9db2d35ef8acf22a6b0c135852ebff3f4a5ab2bb44d"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ea53f1027e080360827574ab470ab22375f160207052af5564067772384b1698"
    sha256 cellar: :any,                 arm64_monterey: "f19cb1418c7c90238f54f4940a7e84dae22dd64b23136d223ee1c8ea445488df"
    sha256 cellar: :any,                 arm64_big_sur:  "6a34eecdd4be5cc343990c89c35799c2b5d9263dffb84214184ba70f8d18cd85"
    sha256 cellar: :any,                 ventura:        "869cde6df1758bf1f01c4e327154cd8e149721ba2958fc72de807eb4f46e2f99"
    sha256 cellar: :any,                 monterey:       "83c95e0a03c4945b8d396326a39930416c088d4f1fa9527a5bc6e8d3769f7892"
    sha256 cellar: :any,                 big_sur:        "92ba7d9b6dc4edd54a23e07cb27bd1a37b3cb61d2baea931e780bbcc9ed7cecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34965550521470f11e239d2905e89b628681a1113d80775e76d490a1062f455a"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "scipy"
  depends_on "simde"

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    # simde include dir can be removed after https://github.com/Simple-Robotics/proxsuite/issues/65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_libexec/"bin/python"}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    python_exe = Formula["python@3.11"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end
