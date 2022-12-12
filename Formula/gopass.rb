class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://ghproxy.com/github.com/gopasspw/gopass/releases/download/v1.15.1/gopass-1.15.1.tar.gz"
  sha256 "0418700a9540997d658166c9a6b97361e7d6e6e0d83c6a347bc69b1b4533bfcf"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "190ce182bc75fbfc1c8b344a4892ed44ebdc581a59ee2a5891476f34a140f25c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3db466695c3903308ca9f36e5dc43d5458f68fcd6d8fef2ad4622d8904ca4c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f3fe4fd86f7e48937112148515ca32233b15399ce00cc3596c6fec6f38857f67"
    sha256 cellar: :any_skip_relocation, ventura:        "34f331a6b7e1a1fe229c172859c99ea6d39578ca9817e8fab4c7e397a607721d"
    sha256 cellar: :any_skip_relocation, monterey:       "2bb48df231338920a47bcc90d57a1cb37d720759d89a8d19a1972944d2a6ee86"
    sha256 cellar: :any_skip_relocation, big_sur:        "49e63096848094196490f88e6883bc8bcc2893551644994f99e722bec093b156"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"

    bash_completion.install "bash.completion" => "gopass.bash"
    fish_completion.install "fish.completion" => "gopass.fish"
    zsh_completion.install "zsh.completion" => "_gopass"
    man1.install "gopass.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/"Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
