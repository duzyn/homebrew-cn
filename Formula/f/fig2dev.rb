class Fig2dev < Formula
  desc "Translates figures generated by xfig to other formats"
  homepage "https://mcj.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mcj/fig2dev-3.2.9a.tar.xz?use_mirror=jaist"
  sha256 "61e185393176852f03b901b3b05b19fbc5ad8258ff142f3da6e70b1b83513326"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/fig2dev[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    sha256 arm64_sequoia: "aebdf1e7cf34ee70d57542077cd5074ae289f18239713ddd49a57d9ff563a516"
    sha256 arm64_sonoma:  "937a6e007c92c11c9ec3bf965241e18d1e190a83c3542dbe901925350e972207"
    sha256 arm64_ventura: "a97284bb9afc2196c9cc4299be7d98950ea6a22b6c59fe0917ce03ebc8cf4a8e"
    sha256 sonoma:        "040e8f13d396fb52f5a15ffd237e37639fd4429e2b0ba0bf3cf5c965ce31e7c6"
    sha256 ventura:       "1f6e1e07ed4b86d59035e074c821d37ebf54348434a5fb222ef722d2cb4543e9"
    sha256 arm64_linux:   "8d5c0689d6650d821e33e7a360a1235c8382cc2517bab0fcc96ad016b5b44c09"
    sha256 x86_64_linux:  "ada9a36cc0cd0cb0f6ee15522a4d579f6a32bc5cc035866e2449759019cacb57"
  end

  depends_on "ghostscript"
  depends_on "libpng"
  depends_on "netpbm"

  uses_from_macos "zlib"

  def install
    system "./configure", "--enable-transfig",
            *std_configure_args.reject { |s| s["--disable-debug"] }
    system "make", "install"

    pkgshare.install "fig2dev/tests/data/patterns.fig"
  end

  test do
    system bin/"fig2dev", "-L", "png", "#{pkgshare}/patterns.fig", "patterns.png"
    assert_path_exists testpath/"patterns.png", "Failed to create PNG"
  end
end
