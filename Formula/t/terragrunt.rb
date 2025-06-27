class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://mirror.ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.82.1.tar.gz"
  sha256 "d0daab2a447848d82b5a1ba95d4af705a13cff198e1e2db526d0ed84c85b86c0"
  license "MIT"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5948dbee67192680ea6ac1567c16b484e5998c307839dcff9bba05d129c125b4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5948dbee67192680ea6ac1567c16b484e5998c307839dcff9bba05d129c125b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5948dbee67192680ea6ac1567c16b484e5998c307839dcff9bba05d129c125b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e5c50ac7a251733de3385f8b40e8fd73af756a9dccbe12abcb0111e68b0b2b05"
    sha256 cellar: :any_skip_relocation, ventura:       "e5c50ac7a251733de3385f8b40e8fd73af756a9dccbe12abcb0111e68b0b2b05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d9ceb18cc1ff85b35c7979c3ed65a2a6d19df37dde67aed05cfdf4ca8a75193"
  end

  depends_on "go" => :build

  conflicts_with "tenv", because: "both install terragrunt binary"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ldflags = %W[
      -s -w
      -X github.com/gruntwork-io/go-commons/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
