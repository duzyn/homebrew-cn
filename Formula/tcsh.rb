class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.06.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.06.tar.gz"
  sha256 "a8cd0cd1ddc94f870681ccbd09a3511050e9a71e5fe99a2b007941f5e1b2b7a5"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "cd792c5cdf985d2e142eeb04c267b28b7534841c932d1c798e956fd6f4815b52"
    sha256 arm64_monterey: "b620bed03c9bc06b223c2da7b91f0effbe02f189dfae3bea4e677b4cddc97a19"
    sha256 arm64_big_sur:  "a168ece35f6cbc671d12124cc2e71a25c4739bf8ff3a80b49d5653bba71c2a7f"
    sha256 ventura:        "aba2dcdc6ad9b2ed1f658d3161ac3a2bd0ca31a1f9056d36d56c6dec6d187576"
    sha256 monterey:       "c5ed380b623dd7604c2964bf84528449018b293ee9e595a3c6d90ccee2dc1e34"
    sha256 big_sur:        "505aa6e6f44f05a8f8305c7b30d992529009f35936c9ff6a869ec1af7b9eb754"
    sha256 x86_64_linux:   "75b2085e0df306892337eb5f5bdbbbfb20a9878f31db2f44ccfc27781be2603f"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
    bin.install_symlink "tcsh" => "csh"
  end

  test do
    (testpath/"test.csh").write <<~EOS
      #!#{bin}/tcsh -f
      set ARRAY=( "t" "e" "s" "t" )
      foreach i ( `seq $#ARRAY` )
        echo -n $ARRAY[$i]
      end
    EOS
    assert_equal "test", shell_output("#{bin}/tcsh ./test.csh")
  end
end
