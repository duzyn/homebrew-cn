class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "8dee269c6ee4045ee31676c3619ad1884c182a92e1b64441b8f0cf3fca005749"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52b470f1b054128ae49efc39c2d801803d90e85444574055dd2b0c4616891981"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0591e0ac5caf1da6a2747849ee3f67e3a2b6dd2b8a12962612843408afbe317c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd878aee71cdba2436c410700bf9ee481fa88767124b14195d37cf41d4a865f5"
    sha256 cellar: :any_skip_relocation, ventura:        "3f3318da0ce10f519e33b9c4194f1026719deabe8c38dad710abd1aadad8e7d8"
    sha256 cellar: :any_skip_relocation, monterey:       "ee491ae6fac989c6f41c3a871222f5077ccfece534bb24c0f74bb5724d428995"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e8698acb61ffbd6118c09558e5a28beb3a5f907bf652cb72ae71e0d60b05c36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "07fc17a9711b4a569f00df653067885650611ac24a92f7ee36e0da29c5c6d2b0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"hermit", ldflags: "-X main.version=#{version} -X main.channel=stable"), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system "hermit", "init"
    assert_predicate testpath/"bin/hermit.hcl", :exist?
  end
end
