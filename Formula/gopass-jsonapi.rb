class GopassJsonapi < Formula
  desc "Gopass Browser Bindings"
  homepage "https://github.com/gopasspw/gopass-jsonapi"
  url "https://ghproxy.com/github.com/gopasspw/gopass-jsonapi/releases/download/v1.15.1/gopass-jsonapi-1.15.1.tar.gz"
  sha256 "b3463f74c563f8220ef9714c660b52eeff88de3ea9e461f46928241b28e565b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f1adaf00c0d37771acea1428e429cf6920af1bcc7e2e69f21401fffce6c3255"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09fa08a4411933c315dca0790988b6414d0a295e47d3ff6a6fac4b85a47ade78"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0137d069bac105475b7a85cdea727dd280c45cdd250cb22bebab314f08489b1"
    sha256 cellar: :any_skip_relocation, ventura:        "0fead53999085231859c4fa855e4069d7654904f69eccd0562b76ca9b8ff1b94"
    sha256 cellar: :any_skip_relocation, monterey:       "1e32f4723665a4d5a14b2eea870c6c9b06496ac9a340f0a98646854f1ca7dcb2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7525d824b5244fca04aabb89d0e5c19311a39ac47539cb53254d49d77708d468"
  end

  depends_on "go" => :build
  depends_on "gopass"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}")
  end

  test do
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

      system Formula["gopass"].opt_bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system Formula["gopass"].opt_bin/"gopass", "generate", "Email/other@foo.bar", "15"
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end

    assert_match(/^gopass-jsonapi version #{version}$/, shell_output("#{bin}/gopass-jsonapi --version"))

    msg = '{"type": "query", "query": "foo.bar"}'
    assert_match "Email/other@foo.bar",
      pipe_output("#{bin}/gopass-jsonapi listen", "#{[msg.length].pack("L<")}#{msg}")
  end
end
