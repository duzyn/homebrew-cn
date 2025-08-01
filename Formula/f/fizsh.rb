class Fizsh < Formula
  desc "Fish-like front end for ZSH"
  homepage "https://github.com/zsh-users/fizsh"
  url "https://downloads.sourceforge.net/project/fizsh/fizsh-1.0.9.tar.gz?use_mirror=jaist"
  sha256 "dbbbe03101f82e62f1dfe1f8af7cde23bc043833679bc74601a0a3d58a117b07"
  license "BSD-3-Clause"
  head "https://github.com/zsh-users/fizsh.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/fizsh[._-]v?(\d+(?:\.\d+)+(?:-\d+)?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "df5876c3cbe6a7389c95edc4e72f7037012b3287ac58ad7b26f27895c85c1a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cbf2b10f9ad45e0c2fa5d94a53a7718359221fe69fbbd197bf09fc68192d402"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "202375740d8f12d64c37f907f2812aa101422ed5b167565b01732eba0b82dd31"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2575105118020a32990c4a46d7c39067a2d68c4bf2f30d657332a322e6dc44c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd8232b33ec452c52f71dc0507985c2895f6735c2a9a76664f31685f3daa8cb3"
    sha256 cellar: :any_skip_relocation, sonoma:         "970dba9691ac7d8fa87e181ea145b5c19f088e8446d12dd812fd70256f0a603e"
    sha256 cellar: :any_skip_relocation, ventura:        "00fb4ac5a875701f9c7a2ae772014c3bf9e44c449c3156ea4ee8cb99fab79dc8"
    sha256 cellar: :any_skip_relocation, monterey:       "2fb1732893a6e83308b526baff15a08cc59af1ddfc5c562ca7c451559ca2d6f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e97c31a73043c5f5b0119865e63ddba6d0df0aeb87eb19fb4434ac2a5d60ba4"
    sha256 cellar: :any_skip_relocation, catalina:       "c1cb674d5a7219ea4c41f3becd0997cf55dfd26a06a17d739f14a3d59da7df75"
    sha256 cellar: :any_skip_relocation, mojave:         "02457429b5257b916207bc7f46acd5577f8e01183437ef03b594991ba3e69466"
    sha256 cellar: :any_skip_relocation, high_sierra:    "7916e571aaf891561a5a6be1ef9708e63ee17ecb41fe60b75129c765d3dad1cb"
    sha256 cellar: :any_skip_relocation, sierra:         "334ceff9d649e87f87be9d3f561ee38221f8c87712a3b506b145191dc51fc4bd"
    sha256 cellar: :any_skip_relocation, el_capitan:     "334ceff9d649e87f87be9d3f561ee38221f8c87712a3b506b145191dc51fc4bd"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ede8c167da0b5c92a8404fe55b54cc8267b9759929ad44e8bd7511afaef6da18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dee528cb55f59e8c34f6c0559a60577250d73cd5b51d5b528c92b0db92006be9"
  end

  depends_on "zsh"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_equal "hello", shell_output("#{bin}/fizsh -c \"echo hello\"").strip
  end
end
