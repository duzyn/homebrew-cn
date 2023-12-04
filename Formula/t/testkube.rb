class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  url "https://mirror.ghproxy.com/https://github.com/kubeshop/testkube/archive/refs/tags/v1.16.11.tar.gz"
  sha256 "069382442a23b1b6098101c20b49602855e4b7e2f1036b2dc53c4a8682e60dca"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "207cf9ee8fdc8cb6422c2e3b19f3dcd4eed5e04509bf3e6ebac89ae54dedfe21"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f9c151160e7d20ada16058f90c60db4137098d1b0d7f209d0093031ea737444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba3709e4689fb9a3b0aea748e162041d03b69c272b6e34f05afe1f682a900ed3"
    sha256 cellar: :any_skip_relocation, sonoma:         "56c9b2294efa305542fe3bd9e3859e34a78956132ba00f94313f736cfd59f8c7"
    sha256 cellar: :any_skip_relocation, ventura:        "b626198c8e1f09a03c0f9f4ad83c4ea9f85a0ea8b3cced082ee5f7c78f116802"
    sha256 cellar: :any_skip_relocation, monterey:       "dc10ec8ad4ebe3979cc50e0415012d8e0b3256f6cc2a8e39d2c5c319f477c48e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "473212feebda27c1bf2b7ec5837ba0e468d922d1612146612e8bc9e7a3c4be70"
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
