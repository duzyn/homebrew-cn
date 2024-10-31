class Trufflehog < Formula
  desc "Find and verify credentials"
  homepage "https://trufflesecurity.com/"
  url "https://mirror.ghproxy.com/https://github.com/trufflesecurity/trufflehog/archive/refs/tags/v3.83.0.tar.gz"
  sha256 "dc11edaa8c5229ce84f9f8ed97fd1c055549c5c807735f31dbe5aeabb279d333"
  # upstream license ask, https://github.com/trufflesecurity/trufflehog/issues/1446
  license "AGPL-3.0-only"
  head "https://github.com/trufflesecurity/trufflehog.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cdc933f8d035aa295d7c23435201e932f1d6d3225f1aef057e37ec7203ba0e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bc5af1acc2932f22ac760c650f560a76da936f6db59241ce0a4977fd99142484"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fe610d7973d5ffa436be49e3035235a8ff78462dbeb96f98ef067fba9ee5fb1d"
    sha256 cellar: :any_skip_relocation, sonoma:        "f192045ce3059c6e7d57a0e27ff1486b66b51167db9a647a341daaf2a884a8d7"
    sha256 cellar: :any_skip_relocation, ventura:       "8a89ec5e4e827296f062ad0a70e32265d341cc6d53d0729a4c1e08236b3962ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f15650cfb0b550df14cf0ccf1910c5ee3eaec236200daf3d4cf5d8791fb1c17f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/trufflesecurity/trufflehog/v3/pkg/version.BuildVersion=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    repo = "https://github.com/trufflesecurity/test_keys"
    output = shell_output("#{bin}/trufflehog git #{repo} --no-update --only-verified 2>&1")
    expected = "{\"chunks\": 0, \"bytes\": 0, \"verified_secrets\": 0, \"unverified_secrets\": 0, \"scan_duration\":"
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}/trufflehog --version 2>&1")
  end
end
