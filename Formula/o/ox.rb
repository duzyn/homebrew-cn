class Ox < Formula
  desc "Independent Rust text editor that runs in your terminal"
  homepage "https://github.com/curlpipe/ox"
  url "https://mirror.ghproxy.com/https://github.com/curlpipe/ox/archive/refs/tags/0.6.0.tar.gz"
  sha256 "63f947bc22c660a651f0ac9c1cec512b9b771a8f60e11e4772c0e5220372d5bb"
  license "GPL-2.0-only"
  head "https://github.com/curlpipe/ox.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "077181f94e60ecf0ca25b0e03a0ed9607c4609eb72875d42794f9f608c3ec5e3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40fcb197e484126a4652372f8c3e1c9484e896eee3a2dfa914253a31f8fb02b1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3bfaec95f335014b1353f47eff31a3b53a0d6e13938807ac6d082ba06e8934ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "71b8a44f691ea75f07e3cd217e996066ba3d0deb2cd1aa3b0e249df80f01e23f"
    sha256 cellar: :any_skip_relocation, ventura:       "06bbeb095594fb9b9fcb552e39220e2c8a9cd67cf9dda71b20e5cf35728cc012"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a528b690ac1105e14c74f75ac6bbe7b0613239de652f1323c9338bba2095a33a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Errno::EIO: Input/output error @ io_fread - /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    require "pty"
    ENV["TERM"] = "xterm"

    PTY.spawn(bin/"ox", "test.txt") do |r, w, pid|
      sleep 1
      w.write "Hello Homebrew!\n"
      w.write "\cS"
      sleep 1
      w.write "\cQ"
      r.read

      assert_match "Hello Homebrew!\n", (testpath/"test.txt").read
    ensure
      Process.kill("TERM", pid)
    end
  end
end
