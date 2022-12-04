class Tcsh < Formula
  desc "Enhanced, fully compatible version of the Berkeley C shell"
  homepage "https://www.tcsh.org/"
  url "https://astron.com/pub/tcsh/tcsh-6.24.03.tar.gz"
  mirror "https://ftp.osuosl.org/pub/blfs/conglomeration/tcsh/tcsh-6.24.03.tar.gz"
  sha256 "7368bfdfa6d0c8b0040d47c00b3dfc17b501e3bc032d05ce816019aa825798f5"
  license "BSD-3-Clause"

  livecheck do
    url "https://astron.com/pub/tcsh/"
    regex(/href=.*?tcsh[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "8edc9990e6f0a4ac81f462cb626c41cf1943a7adc114d6b21e8feb826dd718b5"
    sha256 arm64_monterey: "fb2af01550e78b2795834f6b1874f3e974679d56b12e3117dd17d830c7b238c4"
    sha256 arm64_big_sur:  "09a5790a450e20b00398836dc5b52b960ea0375c17a77fd227550a5e34dcbb1c"
    sha256 ventura:        "f79a16b2b787d59b640560a656a318e3b0841d775e88b9a56ca021769efa2f44"
    sha256 monterey:       "3dbafb4df65b016694b536f397406b3f342115fadf6112e4f665072c0ad26365"
    sha256 big_sur:        "2f276f9845d6ec56a3732fb1652a1238f0c8a626de76ecfcf0ad75ff24ae5cc4"
    sha256 x86_64_linux:   "7feaf032c41264efec2f6884ef2be7cf340d50dfa84c587a6df051e69d0c326a"
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
