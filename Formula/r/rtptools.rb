class Rtptools < Formula
  desc "Set of tools for processing RTP data"
  homepage "https://github.com/irtlab/rtptools"
  url "https://mirror.ghproxy.com/https://github.com/irtlab/rtptools/archive/refs/tags/1.22.tar.gz"
  sha256 "ac6641558200f5689234989e28ed3c44ead23757ccf2381c8878933f9c2523e0"
  license "BSD-3-Clause"
  head "https://github.com/irtlab/rtptools.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "06e5ec34e865108c33c8e34cc136a7d12758ace00639494adeafeabccea7d1e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f7a817f96226b0cc4a1bd1dd656fcbd37b9a2bb4c0a562fdc5c8f40db60530b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d06d42bddd550eb32476e7412d204a11795fa1295c9c68e0b608e652b5092df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b656aa50230fbf083a0acd2bb82b6c9911b0c1e450280f2beba636aea4dd444"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a760c9b142e55aba7732406eeb2603c49b9b7514e02bd01bc245d0661772bf20"
    sha256 cellar: :any_skip_relocation, sonoma:         "691da9365bc23c711cefb7628f72e910113437022a5d8c820058b0912fdbc2df"
    sha256 cellar: :any_skip_relocation, ventura:        "d9f2ab7acb5516a14a0da93a58364e92cd396275a687947d4c1fa6e66419f2d5"
    sha256 cellar: :any_skip_relocation, monterey:       "cc4355761bc5d55ef0bf7ed1b81946cecb40db52832d63dca2ba4a01c5655168"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9f1e8f18d40ba8b435f619de132a5fbc00e0ef84d5a1e10378700e0f3ce417b"
    sha256 cellar: :any_skip_relocation, catalina:       "59fa4c8c53c3430c6bb47b82c752eef710f692ad3fb1bd3ab82c108524aabe00"
    sha256 cellar: :any_skip_relocation, mojave:         "eb8412186a92c44426b2f4c4bef7adcffb308afd4bb036a2dd9d1a0d184b504e"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "fbc5b735cb15f7d17b43615778d6306ed204c56abbf58bccaffe1df79b08f637"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e72d5483db8933643fcdf7793ac236d09f2f28bf2fa8f9db169fe59d90728e3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  on_linux do
    depends_on "libnsl"
  end

  def install
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    packet = [
      0x5a, 0xb1, 0x49, 0x21, 0x00, 0x0d, 0x21, 0xce, 0x7f, 0x00, 0x00, 0x01,
      0x11, 0xd9, 0x00, 0x00, 0x00, 0x18, 0x00, 0x10, 0x00, 0x00, 0x06, 0x8a,
      0x80, 0x00, 0xdd, 0x51, 0x32, 0xf1, 0xab, 0xb4, 0xdb, 0x24, 0x9b, 0x07,
      0x64, 0x4f, 0xda, 0x56
    ]

    (testpath/"test.rtp").open("wb") do |f|
      f.puts "#!rtpplay1.0 127.0.0.1/55568"
      f.write packet.pack("c*")
    end

    output = shell_output("#{bin}/rtpdump -F ascii -f #{testpath}/test.rtp")
    assert_match "seq=56657 ts=854698932 ssrc=0xdb249b07", output
  end
end
