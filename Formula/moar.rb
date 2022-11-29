class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.11.1.tar.gz"
  sha256 "e7f391eff362a94d82b1f57bb6ca9dd78a9c1ae126a3bb4aa385a7607e7dbe5b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54b3030ae99d1dbaeb40ad07c393e365ad41dc3503bdf34481d40ef3f802c887"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54b3030ae99d1dbaeb40ad07c393e365ad41dc3503bdf34481d40ef3f802c887"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54b3030ae99d1dbaeb40ad07c393e365ad41dc3503bdf34481d40ef3f802c887"
    sha256 cellar: :any_skip_relocation, ventura:        "a1ea32537b5be165318065acec126463764061a71ca7a6c41da55a5b79cb9a86"
    sha256 cellar: :any_skip_relocation, monterey:       "a1ea32537b5be165318065acec126463764061a71ca7a6c41da55a5b79cb9a86"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1ea32537b5be165318065acec126463764061a71ca7a6c41da55a5b79cb9a86"
    sha256 cellar: :any_skip_relocation, catalina:       "a1ea32537b5be165318065acec126463764061a71ca7a6c41da55a5b79cb9a86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d07448f00b653f19e64d55d2aceef8be2efb11eef2a8a5af19abad17b2456dc"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
