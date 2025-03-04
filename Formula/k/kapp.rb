class Kapp < Formula
  desc "CLI tool for Kubernetes users to group and manage bulk resources"
  homepage "https://carvel.dev/kapp/"
  url "https://mirror.ghproxy.com/https://github.com/carvel-dev/kapp/archive/refs/tags/v0.64.0.tar.gz"
  sha256 "913a7bce4f2e4596e64d91d0e4259e2dac28adedf6f0737b6d4e01afc7a849a7"
  license "Apache-2.0"
  head "https://github.com/carvel-dev/kapp.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "988fb14b5443bf60238e93290c5e02654e8b3de078d53e86bc27cce529b772e1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "988fb14b5443bf60238e93290c5e02654e8b3de078d53e86bc27cce529b772e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "988fb14b5443bf60238e93290c5e02654e8b3de078d53e86bc27cce529b772e1"
    sha256 cellar: :any_skip_relocation, sonoma:        "0306278aa240526fb267b7f1cbf5b40f10011fcbc3df06d7167fd53e02103f69"
    sha256 cellar: :any_skip_relocation, ventura:       "0306278aa240526fb267b7f1cbf5b40f10011fcbc3df06d7167fd53e02103f69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71646e52dde56f6d7a41d1d1aac4a3c7f8e6af8f4cdd2145788c609f0ad49c30"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X carvel.dev/kapp/pkg/kapp/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/kapp"

    generate_completions_from_executable(bin/"kapp", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kapp version")

    output = shell_output("#{bin}/kapp list 2>&1", 1)
    assert_match "try setting KUBERNETES_MASTER environment variable", output

    output = shell_output("#{bin}/kapp deploy-config")
    assert_match "Copy over all metadata (with resourceVersion, etc.)", output
  end
end
