class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://ghproxy.com/https://github.com/kubeshop/testkube/archive/v1.13.9.tar.gz"
  sha256 "c831c890f3e47109c2e42049caaa7833faaa9c1cab26c446c1d107e3d70c9a10"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be2b2a59ecda7662acc09a9c292cff3e73cf401832073b95c6cc286b77dcc1fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be2b2a59ecda7662acc09a9c292cff3e73cf401832073b95c6cc286b77dcc1fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be2b2a59ecda7662acc09a9c292cff3e73cf401832073b95c6cc286b77dcc1fa"
    sha256 cellar: :any_skip_relocation, ventura:        "f0fbb472cbbb209be3a15ad35322c48885a6444b8c147fd5a1daf060793cf074"
    sha256 cellar: :any_skip_relocation, monterey:       "f0fbb472cbbb209be3a15ad35322c48885a6444b8c147fd5a1daf060793cf074"
    sha256 cellar: :any_skip_relocation, big_sur:        "f0fbb472cbbb209be3a15ad35322c48885a6444b8c147fd5a1daf060793cf074"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19ffc779daefde92b62b153324754f9286767e74f59c89a18d6eb83733f2b6e9"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
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
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
