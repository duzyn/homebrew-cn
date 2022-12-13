class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.7.30.tar.gz"
  sha256 "cba63bc72b22c8d6e91a01b7897e2179a19b7920c5143968844a742930712dfe"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39a56f113bda760b47f27c33cd32c8cd559066f2bd0a114662feef5ddac973b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39a56f113bda760b47f27c33cd32c8cd559066f2bd0a114662feef5ddac973b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39a56f113bda760b47f27c33cd32c8cd559066f2bd0a114662feef5ddac973b1"
    sha256 cellar: :any_skip_relocation, ventura:        "0c680b01183ae967f19e6e411b67a831d0132a960964008b4ff354640af8acf4"
    sha256 cellar: :any_skip_relocation, monterey:       "0c680b01183ae967f19e6e411b67a831d0132a960964008b4ff354640af8acf4"
    sha256 cellar: :any_skip_relocation, big_sur:        "0c680b01183ae967f19e6e411b67a831d0132a960964008b4ff354640af8acf4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb723ab544daf53f9e1c687c570712b9f332a336f66cca92f607d2cc3b434450"
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
