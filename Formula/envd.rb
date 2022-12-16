class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.2.5.tar.gz"
  sha256 "5bcd4785b1d0bbe762b4999165513392c2256a33e0a86a733eb776c1092665b7"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1627f9144f4d09c4b2b6c71d706d6564f4f2a3556fee70b392444663b0394ee1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1627f9144f4d09c4b2b6c71d706d6564f4f2a3556fee70b392444663b0394ee1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1627f9144f4d09c4b2b6c71d706d6564f4f2a3556fee70b392444663b0394ee1"
    sha256 cellar: :any_skip_relocation, ventura:        "ab3ed4b035e2b81ad9104c05cf6ac47018cb58f47dd7a8271092fa5992b873e0"
    sha256 cellar: :any_skip_relocation, monterey:       "ab3ed4b035e2b81ad9104c05cf6ac47018cb58f47dd7a8271092fa5992b873e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "ab3ed4b035e2b81ad9104c05cf6ac47018cb58f47dd7a8271092fa5992b873e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48e3ee9071a4994da99bccb02bc612961798821163f4a908aaf0ccf0c84b2c9f"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip
    system bin/"envd", "init"
    assert_predicate testpath/"build.envd", :exist?
  end
end
