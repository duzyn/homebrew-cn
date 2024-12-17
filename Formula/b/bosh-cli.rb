class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://mirror.ghproxy.com/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.8.4.tar.gz"
  sha256 "ca19b0409d701629e439c461d4e8d9a8b7c2c89653ac2cfd7fad204f3b500a9d"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "466a6ebaa11609f9754c119c2fa485627b5482d759130bca78757ecbdf370ad8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "466a6ebaa11609f9754c119c2fa485627b5482d759130bca78757ecbdf370ad8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "466a6ebaa11609f9754c119c2fa485627b5482d759130bca78757ecbdf370ad8"
    sha256 cellar: :any_skip_relocation, sonoma:        "45d6a56ab365643a943c7964095efb2e303042a066610ceefdde4b5dddbdce18"
    sha256 cellar: :any_skip_relocation, ventura:       "45d6a56ab365643a943c7964095efb2e303042a066610ceefdde4b5dddbdce18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78db035fc5134a19b287d76d3f5fa54c68e7900bac79254393c4a7c5391bd0f6"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_path_exists testpath/"jobs/brew-test"

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
