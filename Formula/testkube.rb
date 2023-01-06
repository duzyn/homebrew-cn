class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.8.15.tar.gz"
  sha256 "c965b7f606e0c41538a7a24dbd4e77c8cbc12594e65088d49a1649b6b98d014c"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "65237a9d8a2a8fa703b1f529f8bd4402c02271501a040d0b370c51f71c241e5f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65237a9d8a2a8fa703b1f529f8bd4402c02271501a040d0b370c51f71c241e5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "65237a9d8a2a8fa703b1f529f8bd4402c02271501a040d0b370c51f71c241e5f"
    sha256 cellar: :any_skip_relocation, ventura:        "e229412c67376eb380b28552628123cf42863326f911c934312ccc26eff5b9e4"
    sha256 cellar: :any_skip_relocation, monterey:       "e229412c67376eb380b28552628123cf42863326f911c934312ccc26eff5b9e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "e229412c67376eb380b28552628123cf42863326f911c934312ccc26eff5b9e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8b073ff1ee1a8afffbc3083ea3d939ba1a9771beea2d29b0488a01dac818cd6"
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
