class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://mirror.ghproxy.com/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.57.0.tar.gz"
  sha256 "3c83bc9b6b7e17bfe21d081ac34aaea0d93bf868bd150e466a7975654f19fce6"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41db5f59b102e521ac6752ac133d7201d2f86ccd20c8ec8deeae46187cd6bfc3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41db5f59b102e521ac6752ac133d7201d2f86ccd20c8ec8deeae46187cd6bfc3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "41db5f59b102e521ac6752ac133d7201d2f86ccd20c8ec8deeae46187cd6bfc3"
    sha256 cellar: :any_skip_relocation, sonoma:        "031a730a379eff7ec3479cf734d5834abe235a53c679b852e8df99d0e89cf1f4"
    sha256 cellar: :any_skip_relocation, ventura:       "031a730a379eff7ec3479cf734d5834abe235a53c679b852e8df99d0e89cf1f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f87d951316515c2e581fc1603e3be966dd1d78d3789ff7efbde116a27c8d00fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "75b0d2aac4010934e243da25fdf72a7c9c19f084924204e37585d84faed08965"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
