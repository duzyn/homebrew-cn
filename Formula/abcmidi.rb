class Abcmidi < Formula
  desc "Converts abc music notation files to MIDI files"
  homepage "https://ifdo.ca/~seymour/runabc/top.html"
  url "https://ifdo.ca/~seymour/runabc/abcMIDI-2022.12.09.zip"
  sha256 "51264a2956817a2a198c7ba245e10b3444b2f18ad8d35e8b4b08834049cd10e0"
  license "GPL-2.0-or-later"

  livecheck do
    url :homepage
    regex(/href=.*?abcMIDI[._-]v?(\d{4}(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75e88b01058660102eb0702124ee0756fdefec229c10b85cd3514b79387f4e91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6b0e1f64b175bde54a5794a73595a73637336a72b68fc37c39cb1ad8be22629"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b5c8c430f2701c02d3b05d8b576f5157cc9841911ac7343f67e13c06d14373c"
    sha256 cellar: :any_skip_relocation, ventura:        "30ce93e5561e611922a62ed05838ff3edf620c2840f40aeb5f64822ee64e6523"
    sha256 cellar: :any_skip_relocation, monterey:       "795b9f3bcada54f4d30faa738b4ec95afea3ad8fde88809699d5372107ae39ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "6aa246c16cf8d6f863e4f0f85328caff3bf72fa9ebbb4c319442077be35c3eb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b02cf71512bd52f555d4afc2334a97ade930d4cec1500c73ff09aec038cd157c"
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
