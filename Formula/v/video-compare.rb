class VideoCompare < Formula
  desc "Split screen video comparison tool using FFmpeg and SDL2"
  homepage "https://github.com/pixop/video-compare"
  url "https://mirror.ghproxy.com/https://github.com/pixop/video-compare/archive/refs/tags/20250825.tar.gz"
  sha256 "b71dd752ba6df3f86b653bb342720fdb899aee655722bdaa810046619e9bc02b"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "33adefe6d8a184a4e2a9d985f92e2be51076831a3cb47f6f5fb1934b5e905004"
    sha256 cellar: :any,                 arm64_sonoma:  "dfd34316f3a0060af4aa4c53164b798f18c47a1eb07e1792fc781c5b35cc307a"
    sha256 cellar: :any,                 arm64_ventura: "2b090576c3cc30daf9fb32cfd813950f9993ad730c86a95f70f581c3727bb638"
    sha256 cellar: :any,                 sonoma:        "f7ff8301373e8f37dd869760b0da68c481c52da67890a762fd00f4b173f32635"
    sha256 cellar: :any,                 ventura:       "6295e84674c901031b1585e376aadaa90f207068d317b19e5566719437f628df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6eab779c5bfe285e28b6e21d5a13576ffb6264ff2b95be769765628fa95dfe50"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "caff00ea46afbbf7c2c5da0bf3d8e9f92ffd0f2cf0fb04ba5d4396a20f13fcb1"
  end

  depends_on "ffmpeg@7"
  depends_on "sdl2"
  depends_on "sdl2_ttf"

  def install
    system "make"
    bin.install "video-compare"
  end

  test do
    testvideo = test_fixtures("test.gif") # GIF is valid ffmpeg input format
    begin
      pid = fork do
        exec bin/"video-compare", testvideo, testvideo
      end
      sleep 3
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
