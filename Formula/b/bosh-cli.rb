class BoshCli < Formula
  desc "Cloud Foundry BOSH CLI v2"
  homepage "https://bosh.io/docs/cli-v2/"
  url "https://mirror.ghproxy.com/https://github.com/cloudfoundry/bosh-cli/archive/refs/tags/v7.8.2.tar.gz"
  sha256 "bbd395478d243aef57215c963a4fd74a6e5730f8ed9d2dc966b5deae8470946a"
  license "Apache-2.0"
  head "https://github.com/cloudfoundry/bosh-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3143f60fbd320dbcf2e317b4c3192a0a2a0cfbab604442a2a3fbcdc5606daea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f3143f60fbd320dbcf2e317b4c3192a0a2a0cfbab604442a2a3fbcdc5606daea"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f3143f60fbd320dbcf2e317b4c3192a0a2a0cfbab604442a2a3fbcdc5606daea"
    sha256 cellar: :any_skip_relocation, sonoma:        "0d472f83d779ac73a7917ec885ec6dfe304261fdfefeb06cde2be5aee019b95d"
    sha256 cellar: :any_skip_relocation, ventura:       "0d472f83d779ac73a7917ec885ec6dfe304261fdfefeb06cde2be5aee019b95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "275d03492946540082ddb79b4d1f5d0030232ca02f95fa32241d9e9cd8773690"
  end

  depends_on "go" => :build

  def install
    # https://github.com/cloudfoundry/bosh-cli/blob/master/ci/tasks/build.sh#L23-L24
    inreplace "cmd/version.go", "[DEV BUILD]", "#{version}-#{tap.user}-#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin/"bosh-cli", "generate-job", "brew-test"
    assert_equal 0, $CHILD_STATUS.exitstatus
    assert_predicate testpath/"jobs/brew-test", :exist?

    assert_match version.to_s, shell_output("#{bin}/bosh-cli --version")
  end
end
