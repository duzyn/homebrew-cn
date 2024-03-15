class GitAnnexRemoteRclone < Formula
  desc "Use rclone supported cloud storage with git-annex"
  homepage "https://github.com/DanielDent/git-annex-remote-rclone"
  url "https://mirror.ghproxy.com/https://github.com/DanielDent/git-annex-remote-rclone/archive/refs/tags/v0.8.tar.gz"
  sha256 "6da12f46d46613cc5a539057052be7d8aa5259bd973ddff2d6ee460d34cd096c"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f307520001060c6f71dc1aaf105d6f0c0415d5398331832e184f6269cf01e544"
  end

  depends_on "git-annex"
  depends_on "rclone"

  def install
    bin.install "git-annex-remote-rclone"
  end

  test do
    # try a test modeled after git-annex.rb's test (copy some lines
    # from there)

    # make sure git can find git-annex
    ENV.prepend_path "PATH", bin

    system "git", "init"
    system "git", "annex", "init"

    (testpath/"Hello.txt").write "Hello!"
    assert !File.symlink?("Hello.txt")
    assert_match(/^add Hello.txt.*ok.*\(recording state in git\.\.\.\)/m, shell_output("git annex add ."))
    system "git", "commit", "-a", "-m", "Initial Commit"
    assert File.symlink?("Hello.txt")

    ENV["RCLONE_CONFIG_TMPLOCAL_TYPE"]="local"
    system "git", "annex", "initremote", "testremote", "type=external", "externaltype=rclone",
                  "target=tmplocal", "encryption=none", "rclone_layout=lower"

    system "git", "annex", "copy", "Hello.txt", "--to=testremote"

    # The steps below are necessary to ensure the directory cleanly deletes.
    # git-annex guards files in a way that isn't entirely friendly of automatically
    # wiping temporary directories in the way `brew test` does at end of execution.
    system "git", "rm", "Hello.txt", "-f"
    system "git", "commit", "-a", "-m", "Farewell!"
    system "git", "annex", "unused"
    assert_match "dropunused 1 ok", shell_output("git annex dropunused 1 --force")
    system "git", "annex", "uninit"
  end
end
