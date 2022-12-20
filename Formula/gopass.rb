class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://ghproxy.com/github.com/gopasspw/gopass/releases/download/v1.15.2/gopass-1.15.2.tar.gz"
  sha256 "8d02d41ca980cd3895bbba53b7842da413bddbfc5d11900235adfc9473e831c2"
  license "MIT"
  head "https://github.com/gopasspw/gopass.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0626f483bf721c4ea13e51ae4c5176ea9458aa994004d301f23bf0321e10f5c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d87832af6bc14dec2ee4798d53e698018789f3988ded2d347b7e69b7e93e2e1b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2aada59d5bfc327e8aff7091846e58b9e11c70d1fb571c2305d63f0191713254"
    sha256 cellar: :any_skip_relocation, ventura:        "2243e96079f198828d4602e4e05fa2bdfdc58caf25a7cc7d4e63c3f3ac986d6c"
    sha256 cellar: :any_skip_relocation, monterey:       "c19f0b0657db7d9452d5becd88bac12a1591db48478729c740c6bfa6e7ce5ddd"
    sha256 cellar: :any_skip_relocation, big_sur:        "78b312ced8a006f68dc574009f99e574f1cd1dfb4f44267bc4f1cf6a493dedd2"
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
