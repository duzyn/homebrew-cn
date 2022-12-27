class Volk < Formula
  include Language::Python::Virtualenv

  desc "Vector Optimized Library of Kernels"
  homepage "https://www.libvolk.org/"
  url "https://ghproxy.com/github.com/gnuradio/volk/releases/download/v2.5.2/volk-2.5.2.tar.gz"
  sha256 "ead6d39d390a03cec0d65d474b5222654103b304f7f00c730d69ea54a2ca7006"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 3
    sha256 arm64_ventura:  "285e2ce57c4bac00d6b9c36674b800453688bfdf64db99de6eb35f0414608cef"
    sha256 arm64_monterey: "757d902d4450c823928b969c21d5569c29531ae064d4032e741b22b56b4be549"
    sha256 arm64_big_sur:  "cdcb8d0d1b047312249bff96cc24307ce6b17685e7d14ccadf2de0f9d05191dd"
    sha256 ventura:        "8c5241b838bbf554e8a61433964cce024df6df465e7d19242db53963833e17f7"
    sha256 monterey:       "f4a29a37e6b16c4b6803bde5b1fb188409e7a9f8f6a3f094da54836b464e83c0"
    sha256 big_sur:        "616a2f972533e6042255d3579f1f8d74c7a94f633557fa9f9f46e17530c7e990"
    sha256 x86_64_linux:   "0ea2de25b01ae3ea3439d1da2bf88f15c8804a11cce24de91c0bb005c78e2fcf"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "orc"
  depends_on "pygments"
  depends_on "python@3.11"

  on_intel do
    depends_on "cpu_features"
  end

  fails_with gcc: "5" # https://github.com/gnuradio/volk/issues/375

  resource "Mako" do
    url "https://files.pythonhosted.org/packages/6d/f2/8ad2ec3d531c97c4071572a4104e00095300e278a7449511bee197ca22c9/Mako-1.2.2.tar.gz"
    sha256 "3724869b363ba630a272a5f89f68c070352137b8fd1757650017b7e06fda163f"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  def install
    python = "python3.11"

    # Set up Mako
    venv_root = libexec/"venv"
    ENV.prepend_create_path "PYTHONPATH", venv_root/Language::Python.site_packages(python)
    venv = virtualenv_create(venv_root, python)
    venv.pip_install resources

    # Avoid references to the Homebrew shims directory
    inreplace "lib/CMakeLists.txt" do |s|
      s.gsub! "${CMAKE_C_COMPILER}", ENV.cc
      s.gsub! "${CMAKE_CXX_COMPILER}", ENV.cxx
    end

    # cpu_features fails to build on ARM macOS.
    args = %W[
      -DPYTHON_EXECUTABLE=#{venv_root}/bin/python
      -DENABLE_TESTING=OFF
      -DVOLK_CPU_FEATURES=#{Hardware::CPU.intel?}
    ]
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Set up volk_modtool paths
    site_packages = prefix/Language::Python.site_packages(python)
    pth_contents = "import site; site.addsitedir('#{site_packages}')\n"
    (venv_root/Language::Python.site_packages(python)/"homebrew-volk.pth").write pth_contents
  end

  test do
    system "volk_modtool", "--help"
    system "volk_profile", "--iter", "10"
  end
end
