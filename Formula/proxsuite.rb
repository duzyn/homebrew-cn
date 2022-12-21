class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghproxy.com/github.com/Simple-Robotics/proxsuite/releases/download/v0.2.15/proxsuite-0.2.15.tar.gz"
  sha256 "0061b83eb5288684d492bb0e181718f228ee9eba54d600d6348eeda941c4fe5c"
  license "BSD-2-Clause"
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7250696e589252ecb40d37bc0875026ad5ba681f1030aac933eccbccdba428d2"
    sha256 cellar: :any,                 arm64_monterey: "9a8eaab66f2ae54292dad0f7593c2f31a977992de36ccb49f4f74c0f921a96e7"
    sha256 cellar: :any,                 arm64_big_sur:  "817c501ed59b391e624895c8a6d6fd7cdc50afd582d56166c1feda53cecf8cff"
    sha256 cellar: :any,                 ventura:        "c4d6e26d50f57d0ddd19a5f1f23a9539269ab0a37fae74011219f823f85c7d3c"
    sha256 cellar: :any,                 monterey:       "fd21c9adea43c92013dd67ba648d6808424188e9b8919ab6210fc3f61fb44856"
    sha256 cellar: :any,                 big_sur:        "519e89b487ea3b8d5f925b8d97a91c44a6b1b99bda1d2954897c2c1f45f0913d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53329a05279fe57a8186e2267313aa92dc20b7bd00cd9bbca5f5270d21db32b5"
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
