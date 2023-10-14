class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://kcachegrind.github.io/"
  url "https://mirrors.ustc.edu.cn/kde/stable/release-service/23.08.2/src/kcachegrind-23.08.2.tar.xz"
  sha256 "9a94125b7a2dcd11253c2361b19e04ec44008ad3e4be1982094849d411936d71"
  license "GPL-2.0-or-later"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://mirrors.ustc.edu.cn/kde/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "c96df67943f68a968eb48589280bea778040597f973167b6b1faedeb3b43ed76"
    sha256 cellar: :any,                 arm64_ventura:  "82cb621b1ce381bf3f4b28ccacda54805170d97a58514632aae60a52e66c436c"
    sha256 cellar: :any,                 arm64_monterey: "800f82105ff23f1ab2c947449003435e68baf7ca9c936e99ba1119359339e78d"
    sha256 cellar: :any,                 sonoma:         "57b4c4f71527eee3ded6cd8c8299fadb44bb41d81f94402bc605678c368ce070"
    sha256 cellar: :any,                 ventura:        "4dad3ba13e978b1b988c5cc242aad9806d92ba61066acc051167f1cf13f0a281"
    sha256 cellar: :any,                 monterey:       "20cec6a8276a872ec8dfbd84b68893dbf5267e142ee02aadd2c3c7035a52ef2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "372d1b0c17fc48a8c7f77b54a3b642af5642b8225fce0024a32ddb0ec6752964"
  end

  depends_on "graphviz"
  depends_on "qt@5"

  fails_with gcc: "5"

  def install
    args = []
    if OS.mac?
      # TODO: when using qt 6, modify the spec
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args = %W[-config release -spec #{spec}]
    end

    system Formula["qt@5"].opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
