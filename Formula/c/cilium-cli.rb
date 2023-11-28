class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://mirror.ghproxy.com/https://github.com/cilium/cilium-cli/archive/refs/tags/v0.15.15.tar.gz"
  sha256 "a5e176554345a721a64c5f51d95aa247e66e4dca25b68391bc58d158f76cf337"
  license "Apache-2.0"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4c1e3643f9e5d4757d0af2f54680118ccdc1ea9b60a78100513bc0c2e8062f20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ced2f43e0c526ed670cd0cf05c5b102f767c39b00f255ae6d2b27846d6386732"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c34d96438f05104064ee9ed4528e8008c475c384dcd0baed3bc20f6c4befcd5e"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed6bb085d8520e99370a54f61a5887a94856e17a9107f40fddfd732070d89f43"
    sha256 cellar: :any_skip_relocation, ventura:        "cd5887f008942995017730baf011b37a08cc995fb9a752eab3fafd8efa7f3b97"
    sha256 cellar: :any_skip_relocation, monterey:       "0b2e069d52456a54d8039144ee82d52807e34b801918dad22f04e00428249787"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0cc4183108fe05bccfda9e521c6a7dd8e9a0d28e417c53dc3a6cc284bd03382"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/cli.Version=v#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match("cilium-cli: v#{version}", shell_output("#{bin}/cilium version 2>&1"))
    assert_match("Kubernetes cluster unreachable", shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
