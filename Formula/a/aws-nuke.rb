class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://mirror.ghproxy.com/https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.38.0.tar.gz"
  sha256 "cff3a50163f9fba8c95a15f11bfdce2c643f930a9fb9dd7dbe756cbe6774417d"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f73981f9599fc331be245e138c5eed9b534980c99fb820fe5265efe2fec7a81c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f73981f9599fc331be245e138c5eed9b534980c99fb820fe5265efe2fec7a81c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f73981f9599fc331be245e138c5eed9b534980c99fb820fe5265efe2fec7a81c"
    sha256 cellar: :any_skip_relocation, sonoma:        "44a31a1b2f5e16f7b39255a9aa0cd23143f653f8ebbb6b0a715f3b6d42b87608"
    sha256 cellar: :any_skip_relocation, ventura:       "44a31a1b2f5e16f7b39255a9aa0cd23143f653f8ebbb6b0a715f3b6d42b87608"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e726743bb9a4a38cc346f51400e36581b107dc40b143b9dbf089ab210cff44b0"
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
