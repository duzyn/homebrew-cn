class Proxsuite < Formula
  desc "Advanced Proximal Optimization Toolbox"
  homepage "https://github.com/Simple-Robotics/proxsuite"
  url "https://ghproxy.com/https://github.com/Simple-Robotics/proxsuite/releases/download/v0.5.0/proxsuite-0.5.0.tar.gz"
  sha256 "c2e928aa35c42fdc5297a81b9dcc6a7f927c8a0b01a18d1984780d67debdaa76"
  license "BSD-2-Clause"
  revision 1
  head "https://github.com/Simple-Robotics/proxsuite.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f204fd9fc3df43dad7c4b419d40f7d3bcb40cf8b60058485df19fb653b5eae14"
    sha256 cellar: :any,                 arm64_ventura:  "f3a1297ab6eb2a692d0768bdf67be2ef9154f562c2c970a34707c2edfbe986d1"
    sha256 cellar: :any,                 arm64_monterey: "2e1fbd058c02dbd6e853911a1a246f17e5b8f72ff3f88dfa9dcbc51009039de9"
    sha256 cellar: :any,                 sonoma:         "02cf28578a3807e4e18af168ff5b805b25af050408f0780f655fc58142915d7f"
    sha256 cellar: :any,                 ventura:        "fa6b1de98bfdf21fb6d4205c2b1e9fb08385a7efb191c83e4520645ef53ee893"
    sha256 cellar: :any,                 monterey:       "fa400ec202a319a65ef09637547f6015cfd0876b5f4f4ac40ce6bb2586dca77c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d72a5c06fef8ccd1487719f0dc3b417d969d3e3a8b6656f1623219217ee5527f"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkg-config" => :build
  depends_on "python-setuptools" => :build
  depends_on "eigen"
  depends_on "numpy"
  depends_on "python@3.12"
  depends_on "scipy"
  depends_on "simde"

  def python3
    "python3.12"
  end

  def install
    system "git", "submodule", "update", "--init", "--recursive" if build.head?

    pyver = Language::Python.major_minor_version python3
    python_exe = Formula["python@#{pyver}"].opt_libexec/"bin/python"

    ENV.prepend_path "PYTHONPATH", Formula["eigenpy"].opt_prefix/Language::Python.site_packages

    # simde include dir can be removed after https://github.com/Simple-Robotics/proxsuite/issues/65
    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{python_exe}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_PYTHON_INTERFACE=ON",
                    "-DINSTALL_DOCUMENTATION=ON",
                    "-DSimde_INCLUDE_DIR=#{Formula["simde"].opt_prefix/"include"}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    pyver = Language::Python.major_minor_version python3
    python_exe = Formula["python@#{pyver}"].opt_libexec/"bin/python"
    system python_exe, "-c", <<~EOS
      import proxsuite
      qp = proxsuite.proxqp.dense.QP(10,0,0)
      assert qp.model.H.shape[0] == 10 and qp.model.H.shape[1] == 10
    EOS
  end
end
