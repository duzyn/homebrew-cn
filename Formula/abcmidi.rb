class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.12.30.zip"
  sha256 "3ed08642ca3100ec48fe7b5a870a650596a8454fbb4992654ead746e9211ce01"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27378d53c82ffe5fa14552bc6c588a269df8c181dd0d5db1801356a86780b243"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5440822b4a895737ea9b0de7455266d8f031319e20716e9f7c00f75fd297669"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd101d9574b1da7233ffc32b20ff53a43c86ec9f9df46cfffeae3e482edd470d"
    sha256 cellar: :any_skip_relocation, ventura:        "7eef88cda1b2dad4fe185e0c92b16cfbb1506b775f7ee760d85d75289c5c017d"
    sha256 cellar: :any_skip_relocation, monterey:       "0130d75bb403f839a06d135ab9f02be8ea0514f17b769a3a8b2521a678b25d2a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ddc7bc2038aa909a26fdf12865addfda7cc60c131355f5b2c98e8068f61b3246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fca9734df67240d3d25dafc89071408e76dbab9023c4d057b248b75d12339e8"
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"balk.abc").write <<~EOS
      X: 1
      T: Abdala
      F: https://www.youtube.com/watch?v=YMf8yXaQDiQ
      L: 1/8
      M: 2/4
      K:Cm
      Q:1/4=180
      %%MIDI bassprog 32 % 32 Acoustic Bass
      %%MIDI program 23 % 23 Tango Accordian
      %%MIDI bassvol 69
      %%MIDI gchord fzfz
      |:"G"FDEC|D2C=B,|C2=B,2 |C2D2   |\
        FDEC   |D2C=B,|C2=B,2 |A,2G,2 :|
      |:=B,CDE |D2C=B,|C2=B,2 |C2D2   |\
        =B,CDE |D2C=B,|C2=B,2 |A,2G,2 :|
      |:C2=B,2 |A,2G,2| C2=B,2|A,2G,2 :|
    EOS

    system "#{bin}/abc2midi", (testpath/"balk.abc")
  end
end
