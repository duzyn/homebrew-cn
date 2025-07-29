class Mise < Formula
  desc "Polyglot runtime manager (asdf rust clone)"
  homepage "https://mise.jdx.dev/"
  url "https://mirror.ghproxy.com/https://github.com/jdx/mise/archive/refs/tags/v2025.7.29.tar.gz"
  sha256 "c421eb07317fc45791e3f2183c2d25c705152b5cc0ae09ef7e2ba5175cb15bef"
  license "MIT"
  head "https://github.com/jdx/mise.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "12a7fc5468baedffc04e17eb0a49953f0c27ea1820e401287a8bd370f05f252d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c6ae6c7b6fe05cac65970ac4692df5dc20c4a5ee063bf5319b567efb44cf129"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7b21571b7fbe00ab6e2c5afbc3dc6cafa963c85b38ed8e0169b625c7a6ae95b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6d80936cf4fe69218fc57d806e5b5614ad641d6ffcbfceb88f47afc38184359c"
    sha256 cellar: :any_skip_relocation, ventura:       "9921aa861ccf001dfeb103548002b647b463834d6389fba4202d74e6d0bff166"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eeb408198d37cca0bf1524528a05450d18a219bcb0725836005531d0984198ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fed505ef16c015ed312af2471cedb41d12b957b9fb70774546d046495ea0bc66"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  depends_on "usage"

  uses_from_macos "bzip2"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install "man/man1/mise.1"
    lib.mkpath
    touch lib/".disable-self-update"
    (share/"fish"/"vendor_conf.d"/"mise-activate.fish").write <<~FISH
      if [ "$MISE_FISH_AUTO_ACTIVATE" != "0" ]
        #{opt_bin}/mise activate fish | source
      end
    FISH

    # Untrusted config path problem, `generate_completions_from_executable` is not usable
    bash_completion.install "completions/mise.bash" => "mise"
    fish_completion.install "completions/mise.fish"
    zsh_completion.install "completions/_mise"
  end

  def caveats
    <<~EOS
      If you are using fish shell, mise will be activated for you automatically.
    EOS
  end

  test do
    system bin/"mise", "settings", "set", "experimental", "true"
    system bin/"mise", "use", "go@1.23"
    assert_match "1.23", shell_output("#{bin}/mise exec -- go version")
  end
end
