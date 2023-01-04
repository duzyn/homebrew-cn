class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https://dystroy.org/broot/"
  url "https://github.com/Canop/broot/archive/v1.19.0.tar.gz"
  sha256 "3345bd0eb17f954212bd12528c476acaa0e4dacb38ad78a047b5aedc2f638c15"
  license "MIT"
  head "https://github.com/Canop/broot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10f75be2172b93fc24a35d33a9e861005b0e20c637928f680cdcdc5ed76340cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bf70cef8d778925b8f4dfd4154044813524df778912f91f23e1c784ea52c779"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5082c84ee025e26962a189584fe8cb0d99f0ea449d3c649d019f85dee7c3753b"
    sha256 cellar: :any_skip_relocation, ventura:        "6f63aede4c3d540a93df9a9640f0815701fb0d8b869797e399fd14ad3e5e1350"
    sha256 cellar: :any_skip_relocation, monterey:       "065430a966eb09683102c1aa0d841f46a665e4dbbe029ba879238410b3ddb40c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f01baf399894aa9b0d94f1858d80d4bfdadec0908c933c370e66ccf9f9bd2cb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0464c26370d5e00ccc158b513f8ef8074903824796ee6c13a4d537158e66d04d"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "man/page" do |s|
      s.gsub! "#version", version
      s.gsub! "#date", time.strftime("%Y/%m/%d")
    end
    man1.install "man/page" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["target/release/build/broot-*/out"].first
    bash_completion.install "#{out_dir}/broot.bash"
    bash_completion.install "#{out_dir}/br.bash"
    fish_completion.install "#{out_dir}/broot.fish"
    fish_completion.install "#{out_dir}/br.fish"
    zsh_completion.install "#{out_dir}/_broot"
    zsh_completion.install "#{out_dir}/_br"
  end

  test do
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    assert_match "A tree explorer and a customizable launcher", shell_output("#{bin}/broot --help 2>&1")

    require "pty"
    require "io/console"
    PTY.spawn(bin/"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath/"output.txt",
                err: :out) do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r"
      assert_match "New Configuration files written in", r.read
      Process.wait(pid)
    end
    assert_equal 0, $CHILD_STATUS.exitstatus
  end
end
