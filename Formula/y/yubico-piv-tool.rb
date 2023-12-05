class YubicoPivTool < Formula
  desc "Command-line tool for the YubiKey PIV application"
  homepage "https://developers.yubico.com/yubico-piv-tool/"
  url "https://developers.yubico.com/yubico-piv-tool/Releases/yubico-piv-tool-2.4.0.tar.gz"
  sha256 "5df8e95c70a85183a88ae48b4a4d81886d7e21ee1c075ce5e39e5ac535e7570a"
  license "BSD-2-Clause"

  livecheck do
    url "https://developers.yubico.com/yubico-piv-tool/Releases/"
    regex(/href=.*?yubico-piv-tool[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "dc612cdfb020d485b2d3894dd37dd928ea5df4a8ea244cb325925d66351552e3"
    sha256 cellar: :any,                 arm64_ventura:  "3ee68594ddf363efd4ca91134f9ada3e898a21ef93e0b9155fd1d1df5e5033ed"
    sha256 cellar: :any,                 arm64_monterey: "83f2044b048bc31f48c443e43a5d652725a638b2c43ba40024ce7a4e8007e5e6"
    sha256 cellar: :any,                 sonoma:         "ea66e39f87ba8d1b8a35651a881766d2ee930efbbe0a8d44ac3328577d1e5b92"
    sha256 cellar: :any,                 ventura:        "03b9471d477d00267f79a71024b0d70eca8709118799bed7d9b20080dc77f2d6"
    sha256 cellar: :any,                 monterey:       "26e4dcd9f13701857ad0c11871bb54b1bb3c4a8bbb65a2dcb58fec2ea75a2be5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "08715a8b248b77a2b1a6b3cece7aebf23ff8f4436d2ee3b2b99d0c85fa793c7a"
  end

  depends_on "check" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "check"
  depends_on "openssl@3"
  depends_on "pcsc-lite"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DCMAKE_C_FLAGS=-I#{Formula["pcsc-lite"].opt_include}/PCSC"
      system "make", "install"
    end
  end

  test do
    assert_match "yubico-piv-tool #{version}", shell_output("#{bin}/yubico-piv-tool --version")
  end
end
