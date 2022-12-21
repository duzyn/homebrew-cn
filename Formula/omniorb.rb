class Omniorb < Formula
  desc "IOR and naming service utilities for omniORB"
  homepage "https://omniorb.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/omniorb/omniORB/omniORB-4.2.4/omniORB-4.2.4.tar.bz2?use_mirror=nchc"
  sha256 "28c01cd0df76c1e81524ca369dc9e6e75f57dc70f30688c99c67926e4bdc7a6f"
  license "GPL-2.0-or-later"
  revision 2

  livecheck do
    url :stable
    regex(%r{url=.*?/omniORB[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "a308bc4486945c18bad8b0796a7dd86a2d3c7721e156f22dd6ab1e9ce51d9a54"
    sha256 cellar: :any,                 arm64_monterey: "8cef87c6d73af069fafd91f2ca931523817322736586289e5088b856c527ea21"
    sha256 cellar: :any,                 arm64_big_sur:  "ba9bb9a6529143c3693da1f7a74cd64732e14ef6ed864298eaa284e6e6b01606"
    sha256 cellar: :any,                 ventura:        "6f6618da8505b338a4abf668311713636d7e5c27f6ef3c1c16e34d7508d417b3"
    sha256 cellar: :any,                 monterey:       "6492666d50cc8f9a7293fc56200d3b4c2a7d77f0c0d08331ee63c783751c7ba3"
    sha256 cellar: :any,                 big_sur:        "d9509e89052992d107acb49321970b248435f0e9f6d353bc7ad19c8a34a886e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "238a916ca3cc0effcc4b5374c88e0d2749ee0b548b4345cc6c684d1fc6ef2507"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11"

  resource "bindings" do
    url "https://downloads.sourceforge.net/project/omniorb/omniORBpy/omniORBpy-4.2.4/omniORBpy-4.2.4.tar.bz2?use_mirror=nchc"
    sha256 "dae8d867559cc934002b756bc01ad7fabbc63f19c2d52f755369989a7a1d27b6"
  end

  def install
    ENV["PYTHON"] = python3 = which("python3.11")
    xy = Language::Python.major_minor_version python3
    inreplace "configure",
              /am_cv_python_version=`.*`/,
              "am_cv_python_version='#{xy}'"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"

    resource("bindings").stage do
      inreplace "configure",
                /am_cv_python_version=`.*`/,
                "am_cv_python_version='#{xy}'"
      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/omniidl", "-h"
    system "#{bin}/omniidl", "-bcxx", "-u"
    system "#{bin}/omniidl", "-bpython", "-u"
  end
end
