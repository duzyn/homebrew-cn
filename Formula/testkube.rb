class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.8.0.tar.gz"
  sha256 "224795114dc0249d7eac46226a071322b89ca3fd3e1a709a456c86f03236e7ec"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "441c91c3c99b8609b0bae2d650beca5eef74d27c946d6a5727e43a365bb6c078"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "441c91c3c99b8609b0bae2d650beca5eef74d27c946d6a5727e43a365bb6c078"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "441c91c3c99b8609b0bae2d650beca5eef74d27c946d6a5727e43a365bb6c078"
    sha256 cellar: :any_skip_relocation, ventura:        "754238e07a3a9adfcd051d495a5e8943ae459d45805cf9671ed71ea961e0f021"
    sha256 cellar: :any_skip_relocation, monterey:       "754238e07a3a9adfcd051d495a5e8943ae459d45805cf9671ed71ea961e0f021"
    sha256 cellar: :any_skip_relocation, big_sur:        "754238e07a3a9adfcd051d495a5e8943ae459d45805cf9671ed71ea961e0f021"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fcb4c99d5398d268e6c272cf26c5b0c92ed7976371ced8611991a022396eb8a"
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
