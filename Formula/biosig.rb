class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.5.0.src.tar.xz?use_mirror=nchc"
  sha256 "25ffaf0ee906904e6af784f33ed1ad8ad55280e40bc9dac07a487833ebd124d0"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dd3667769add1c30892a7b969cc0f45b45344ec1fee673cb8556f6587b48ab34"
    sha256 cellar: :any,                 arm64_monterey: "f5de609bee08a5172c5f4b06e6ccf5f0bab18701d84f2f99df00979eed35fccf"
    sha256 cellar: :any,                 arm64_big_sur:  "993f8b434a7c15e2041cd400fa129be7cafdc74f7a00bcb79c66ded48c096c57"
    sha256 cellar: :any,                 ventura:        "0c06ba1ef7f047ada89b89f0f7579bf03ae9740d792d2689d5f5f8749932a3b4"
    sha256 cellar: :any,                 monterey:       "23e15b18438a2846d85704d77f45a787094389bea5e9ba9407f3011bd76430c5"
    sha256 cellar: :any,                 big_sur:        "75a085001a0e0e839d0e5ee5fe8fef1ab4cb0228291a2dfd448f134408a869e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb2adcbeeb3401ae64e7cf49384920ac777fd8935e24729b8a3898be984c0cef"
  end

  depends_on "gawk" => :build
  depends_on "libarchive" => :build
  depends_on "dcmtk"
  depends_on "libb64"
  depends_on "numpy"
  depends_on "suite-sparse"
  depends_on "tinyxml"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make"
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end
