class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.io"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.5.0.src.tar.xz?use_mirror=nchc"
  sha256 "25ffaf0ee906904e6af784f33ed1ad8ad55280e40bc9dac07a487833ebd124d0"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "39103f5bdf2520b14a15e66f683fed1eabb55ee4751a1555a6cfc1db74e77ec2"
    sha256 cellar: :any,                 arm64_monterey: "502459759d0917b6b5874e6ede9ecf00fa8598c69dfaf6e7f9b1a52a6eb17aec"
    sha256 cellar: :any,                 arm64_big_sur:  "ef3d1c676611e05cf273a2f134fee3f379371380be4992d432938fb9ded37d57"
    sha256 cellar: :any,                 ventura:        "c839bb2499b8e9a5e95d8fb1538feef5b9ef09fbb6bc6058d2faa1294df875d2"
    sha256 cellar: :any,                 monterey:       "d553bb6f98ea1067f7d6bb02540a50115b801bb72329eabad960c43bc1fc815d"
    sha256 cellar: :any,                 big_sur:        "9fc9d4522556e6b6495cadc1f88ebd518e776df4014d175e1396c778147dec6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e92f7b5bf2367f2a37d800b0f049d0e8692099bc490356c77a07ce0e92a014b"
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
