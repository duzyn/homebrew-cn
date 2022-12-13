class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.57.1.tar.gz"
  sha256 "126c94a9611f06391e22c961e4ad91cfd64074915482b40c8db53a98b072114d"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "842b00424541713fcfdc5fb46d2b626ef10ac29a0eb6d6313b19cd35b2f88c9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f8987b21ebf1bd61e9aa5f4b9f7e70f8bc74f81b455e5224e7accaa811c8e6a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a4290654d82983b46b03f9ecd9dfa8804db5ae9fd1624b56b9be77b05ff1197"
    sha256 cellar: :any_skip_relocation, ventura:        "c512badc45969993a11a97bb7c2e41c54134a801b38e2c89faaee7a3c82a793a"
    sha256 cellar: :any_skip_relocation, monterey:       "2480c2f54bf070ff272ac10a3ef69c651281400e2f8af456fdd563765c7a9ea1"
    sha256 cellar: :any_skip_relocation, big_sur:        "94efea82ec896d53caf267bf97ad3efaef24a886cab93217246a7f50aafaad6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "061fa059191b36dfc760e44a01a6e7553629453de11ffce7564e8afad1268d45"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.rfc3339}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
