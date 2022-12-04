class GpgTui < Formula
  desc "Manage your GnuPG keys with ease! 🔐"
  homepage "https://github.com/orhun/gpg-tui"
  url "https://github.com/orhun/gpg-tui/archive/v0.9.2.tar.gz"
  sha256 "c6392f3209146b85c68a328abf2083590ba3c7696545d1efbc4f72b497469ecc"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2a47c27143317bac40dfeae63aa4cd2248775fd7ac59c82fbf8d212c1a213ea5"
    sha256 cellar: :any,                 arm64_monterey: "073d1bd182b49e0b69655244d2fa263f59bd8dc147b4179843d845e72acfdb9b"
    sha256 cellar: :any,                 arm64_big_sur:  "6c0740765304e1bcb96b73a631dd90e48e72c573829a9e24a7dbe2fc554f9911"
    sha256 cellar: :any,                 ventura:        "73d60f46c1898e62c99acc5491f198a9a8afa845b3f75341a3569b1626b09f50"
    sha256 cellar: :any,                 monterey:       "129cb989c186124f238330f43dbf7a22171d1530569c340165630499d80ed4b2"
    sha256 cellar: :any,                 big_sur:        "6f6102b9e78f4a70c1d27ef8966252a11a4010dbd987ce1e7eba6fd37f7491c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5f17936fe84638547a6b4170841e01376553e5c4c4c59d7c6876f11d4c867bf"
  end

  depends_on "rust" => :build
  depends_on "gnupg"
  depends_on "gpgme"
  depends_on "libgpg-error"
  depends_on "libxcb"

  def install
    system "cargo", "install", *std_cargo_args

    ENV["OUT_DIR"] = buildpath
    system bin/"gpg-tui-completions"
    bash_completion.install "gpg-tui.bash"
    fish_completion.install "gpg-tui.fish"
    zsh_completion.install "_gpg-tui"

    rm_f bin/"gpg-tui-completions"
    rm_f Dir[prefix/".crates*"]
  end

  test do
    require "pty"
    require "io/console"

    (testpath/"gpg-tui").mkdir
    begin
      r, w, pid = PTY.spawn "#{bin}/gpg-tui"
      r.winsize = [80, 43]
      sleep 1
      w.write "q"
      assert_match(/^.*<.*list.*pub.*>.*$/, r.read)
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
