class AstrometryNet < Formula
  include Language::Python::Virtualenv

  desc "Automatic identification of astronomical images"
  homepage "https://github.com/dstndstn/astrometry.net"
  url "https://ghproxy.com/github.com/dstndstn/astrometry.net/releases/download/0.92/astrometry.net-0.92.tar.gz"
  sha256 "d6eec262bb8979028d64ea05322f80eec275d7aaeed5efd537e2a79410c678a5"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4c963fa7d64d61b0ab80a4d256927c2618fd59b094f70662a2181064f3e1127c"
    sha256 cellar: :any,                 arm64_monterey: "4d5ae0449dbb029acea4edc7861420a3638ba9991e011a30873bc0e6cef1abb5"
    sha256 cellar: :any,                 arm64_big_sur:  "46ddbaa8a6836f310b4ca401ee92908653f65db846b291ec83c3521a18c6fd5b"
    sha256 cellar: :any,                 ventura:        "35159b32c2ffb9f3026ba8f576c660fe8e72d812bbd957ecc6ab56d729884389"
    sha256 cellar: :any,                 monterey:       "1e53c10f51e47c59a6ce6093b6bc33cb78edd07822ef15d06aac54f71cc67514"
    sha256 cellar: :any,                 big_sur:        "a075c24e76fa2b447f501a8c8d5d950c0ee2ee2c190e6668e241987f8cdb6ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8562e1b4028cd038f7f1e7a0906d8589f79f4320769d583c318ed299768404a4"
  end

  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "cfitsio"
  depends_on "gsl"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "netpbm"
  depends_on "numpy"
  depends_on "python@3.11"
  depends_on "wcslib"

  resource "fitsio" do
    url "https://files.pythonhosted.org/packages/1f/0e/b312ff3f6b588c13fc2256a5df4c4d63c527a07e176012d0593136af53ee/fitsio-1.1.8.tar.gz"
    sha256 "61f569b2682a0cadce52c9653f0c9b81f951d000522cef645ce1cb49f78300f9"
  end

  def install
    # astrometry-net doesn't support parallel build
    # See https://github.com/dstndstn/astrometry.net/issues/178#issuecomment-592741428
    ENV.deparallelize

    python = which("python3.11")
    ENV["NETPBM_INC"] = "-I#{Formula["netpbm"].opt_include}/netpbm"
    ENV["NETPBM_LIB"] = "-L#{Formula["netpbm"].opt_lib} -lnetpbm"
    ENV["SYSTEM_GSL"] = "yes"
    ENV["PYTHON"] = python

    venv = virtualenv_create(libexec, python)
    venv.pip_install resources

    ENV["INSTALL_DIR"] = prefix
    site_packages = Language::Python.site_packages(python)
    ENV["PY_BASE_INSTALL_DIR"] = libexec/site_packages/"astrometry"
    ENV["PY_BASE_LINK_DIR"] = libexec/site_packages/"astrometry"
    ENV["PYTHON_SCRIPT"] = libexec/"bin/python"

    system "make"
    system "make", "py"
    system "make", "install"

    rm prefix/"doc/report.txt"
  end

  test do
    system bin/"image2pnm", "-h"
    system bin/"build-astrometry-index", "-d", "3", "-o", "index-9918.fits",
                                            "-P", "18", "-S", "mag", "-B", "0.1",
                                            "-s", "0", "-r", "1", "-I", "9918", "-M",
                                            "-i", prefix/"examples/tycho2-mag6.fits"
    (testpath/"99.cfg").write <<~EOS
      add_path .
      inparallel
      index index-9918.fits
    EOS
    system bin/"solve-field", "--config", "99.cfg", prefix/"examples/apod4.jpg",
                              "--continue", "--dir", "."
    assert_predicate testpath/"apod4.solved", :exist?
    assert_predicate testpath/"apod4.wcs", :exist?
  end
end
