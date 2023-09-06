class Dump1090Mutability < Formula
  desc "ADS-B Ground Station System for RTL-SDR"
  homepage "https://packages.ubuntu.com/jammy/dump1090-mutability"
  url "http://archive.ubuntu.com/ubuntu/pool/universe/d/dump1090-mutability/dump1090-mutability_1.15~20180310.4a16df3+dfsg.orig.tar.gz"
  version "1.15_20180310-4a16df3-dfsg"
  sha256 "778f389508eccbce6c90d7f56cd01568fad2aaa5618cb5e7c41640a2473905a6"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "e1f3aa536671fde02124bddd715178ee5d0b266fabf4e6d43ce135a68b59f45a"
    sha256 cellar: :any,                 arm64_monterey: "f64f60c73b50111b88b5df4774aca4023b36258ad33c5083b269eb21fd7daf2f"
    sha256 cellar: :any,                 arm64_big_sur:  "f1e9ca781c03d1849d08f376dc122b57a4d067d11596b702b49de37224e1c92c"
    sha256 cellar: :any,                 ventura:        "b34244eb00803fcec744a21a1a4ac4df5202cdf8d78189bf461c57215a8ab766"
    sha256 cellar: :any,                 monterey:       "3e41170d72ad2de375987bc650d594441bc16601f8428eba86f5eeae7c39daa5"
    sha256 cellar: :any,                 big_sur:        "8d51bc82f21df1ddbcf4ce4368a5be8dfc8351a806fcd7c159f31be04ce24806"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea07fc4579770d87a71e9105aa7331231eb620a8aee3ad6d307ece0e61f92d05"
  end

  depends_on "pkg-config" => :build
  depends_on "librtlsdr"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `...'; ....o:(.bss+0x0): first defined here
    ENV.append_to_cflags "-fcommon" if OS.linux?

    system "make"
    bin.install "dump1090"
    bin.install "view1090"
  end

  test do
    require "base64"
    enc="goB/en99g4B9gH6Eg35/fICVhJl/gXx9f4F+f36Af4B/f3+AgH9+f39/gH+Af4CBf4F/f3
    9/f3+AgIGAgH9/f4F/gX9/gH+Bf4B/f3+Af4F+f359gX5/f36BgYB9fIeGm46Ig3p+mIGYfX19f
    oGFf4B/gIGAf3+AgoR8dHVle3iBhH98fn6AgIB+gIB/gIF/f4F+gYCAf3+AfoB/fX6CgICAen6K
    i5WQhIF6foOBgYB9g454lW6CfH2Cg36AgYCBgX6Af4CAf4B/gICAf39/gICAf39/gICAf35/f4B
    /f35+fn6Af4B/f4B/gIB+f35+gX+BfoF/f39/fYF/fIGDgYF/aHttfISAgIB9gYGBfn6AgIF8fn
    6DlIaXgYF+fn+Df3+AgH+Cf4CAgH+Af4CAf4B+f4CAgH9+f39/foGCgH9xbG1wf4KDgHl/hIGCf
    mSIc4mYfJB9jHSUb4N+e36CgYCCfmp/a3p1cmh3dYGHf39+foCAfX9+gIF9cIddm2ybhIV/e3qZ
    gqyBkYiJjZSHipOJlYp9fIN+pn+ncol3eoGJd5lgjVt+eoCEe2V3aHt5Z2RfY3R8bntjen6BgYB
    hiFmZc46FeXuMd5x/iX+Siq2PmH17hoWUk42GkoGVgpF7k3yOd49wjnSGbIdrhHB8Z3xwfHBsWG
    Vlf4N/gGR4bXlwg2eIdoJpkFyfd417jHWdg4h+eYSal6qNkIyFk42PhZaAkYOOeplyhnl3fpBvm
    FeEYn6Ff3x4ZHlydnNjYmNwfIN/gGN9UYVli4CBfH1mk2OmeZmDfnuFhqaQpIaIjoyWkYF+f32d
    h6t7knV7got4lGmEd4hsi1CAaXx5dGR4dYOGcXFncn2CgoF7gH+Cf4F+f4CAf4GAgYF/gH+AgIB
    /f39/gIF+gH1/f3+Af4CAfoB+f39/gYB/fn5+gIB+fX5+gIJ+e4CCf4F+XYpcjnmGcJBxk4N9fI
    R7qIiphox+fIWLm52kkoh/fIGXgJd7iH2dbKBkhXaHb4tkfn1+gX1fa1VzcoeFdnhlc3R8bXxQh
    mOMg395hmySdo97knuTgI6CkYWTiZKKkJCKkYiPh5iBkn+Pfqhvn2t9gYB9jGaHcIBwfGZ/dHNp
    ZFpzc3N5Y3N3gYOAY39TkGuSgoB8f22ecqp8joKOhp5+hYF8kJOPjZKAlIeQg5d5kX6PeKJnlmy
    Bc4hshW18a4BrfXBwaXVzhIVxdVJvY311gGSGb4WFfHOMbZd7iXiYfa6Dk354hYqNloyKkIiRiJ
    J/k4CRfpVyj3mNdplbj2aAd4Njgm19hnlwdWdxd21zbnRufWw="
    plain = Base64.decode64(enc)
    (testpath/"input.bin").write plain
    result = <<~EOS
      *5d4d20237a55a6;
      CRC: 000000\nRSSI: -14.3 dBFS
      Score: 750\nTime: 206.33us
      DF:11 AA:4D2023 IID:0 CA:5
       All Call Reply
        ICAO Address:  4D2023 (Mode S / ADS-B)
        Air/Ground:    airborne
    EOS
    assert_equal result.strip, shell_output("#{bin}/dump1090 --ifile input.bin 2>/dev/null").strip
  end
end
