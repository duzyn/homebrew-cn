class Txt2man < Formula
  desc "Converts flat ASCII text to man page format"
  homepage "https://github.com/mvertes/txt2man/"
  url "https://mirror.ghproxy.com/https://github.com/mvertes/txt2man/archive/refs/tags/txt2man-1.7.1.tar.gz"
  sha256 "4d9b1bfa2b7a5265b4e5cb3aebc1078323b029aa961b6836d8f96aba6a9e434d"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(/^(?:txt2man[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02ec46f5c280b3f46b613be3394a713727e1765199f90d5240505803d75f4a19"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "665ae11624c51ed123faad382b4af7256b5e055c235d54f1d063e58589380909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "665ae11624c51ed123faad382b4af7256b5e055c235d54f1d063e58589380909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "665ae11624c51ed123faad382b4af7256b5e055c235d54f1d063e58589380909"
    sha256 cellar: :any_skip_relocation, sonoma:         "95c0f0a4e3fe25685955b8597d9937e10080a91c31a70ff8eb0fd877cc624f06"
    sha256 cellar: :any_skip_relocation, ventura:        "bf830d1619712538f9458fdd8c6e201d883297ee6e7210dd9e8d977318de216e"
    sha256 cellar: :any_skip_relocation, monterey:       "bf830d1619712538f9458fdd8c6e201d883297ee6e7210dd9e8d977318de216e"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf830d1619712538f9458fdd8c6e201d883297ee6e7210dd9e8d977318de216e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "665ae11624c51ed123faad382b4af7256b5e055c235d54f1d063e58589380909"
  end

  depends_on "gawk"

  def install
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"foo.txt").write "foo"
    (testpath/"foo.1").write Utils.safe_popen_read(bin/"txt2man", "-d", "17 Dec 2022", testpath/"foo.txt")

    expected = <<~EOS
      .\\" Text automatically generated by txt2man
      .TH untitled  "17 Dec 2022" "" ""
      .RS
      foo
    EOS

    assert_equal expected, (testpath/"foo.1").read
  end
end
