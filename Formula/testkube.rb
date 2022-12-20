class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.8.5.tar.gz"
  sha256 "3f7a4e4e99d772d016b4f30618dd3e0be226eb721a3c0dede9fb93ea6ad4c1b0"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "18b29bb358fec6df55a71ab76344d66511a6d04043c265cfad596f72dd46baf8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18b29bb358fec6df55a71ab76344d66511a6d04043c265cfad596f72dd46baf8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18b29bb358fec6df55a71ab76344d66511a6d04043c265cfad596f72dd46baf8"
    sha256 cellar: :any_skip_relocation, ventura:        "067306ef805cb22b23e0c836a7f54727a5c62d7eed8c6aef0dd1ab9ff04e7f22"
    sha256 cellar: :any_skip_relocation, monterey:       "067306ef805cb22b23e0c836a7f54727a5c62d7eed8c6aef0dd1ab9ff04e7f22"
    sha256 cellar: :any_skip_relocation, big_sur:        "067306ef805cb22b23e0c836a7f54727a5c62d7eed8c6aef0dd1ab9ff04e7f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3da6dfc84dcc33bdf9c0283e97ae9b725a70c2e8a8c78e91dab0f96bf51c3774"
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
