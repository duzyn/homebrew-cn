class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.8.10.tar.gz"
  sha256 "dcd50402ebfa1736281f446a47ea878faaf4f7913659925c93ed3792eaddb14f"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "58fde71c9609d3554f22c8dd835139b4461ffe463cd84c976cba15fb32ed0d9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58fde71c9609d3554f22c8dd835139b4461ffe463cd84c976cba15fb32ed0d9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "58fde71c9609d3554f22c8dd835139b4461ffe463cd84c976cba15fb32ed0d9e"
    sha256 cellar: :any_skip_relocation, ventura:        "a556ca67606e4d2296481dfe89aa9389bcd10908824c89142a904d1a847cb899"
    sha256 cellar: :any_skip_relocation, monterey:       "a556ca67606e4d2296481dfe89aa9389bcd10908824c89142a904d1a847cb899"
    sha256 cellar: :any_skip_relocation, big_sur:        "a556ca67606e4d2296481dfe89aa9389bcd10908824c89142a904d1a847cb899"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c06625725ae032174df6e66d8bf682444b86b862c0ed93a3cb171c3d4ac1112"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
