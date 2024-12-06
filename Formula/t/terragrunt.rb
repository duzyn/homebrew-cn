class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://mirror.ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.69.8.tar.gz"
  sha256 "56f153cd4a0fffe30ddbfb8e744ebb77da7b9383b37d236e6c2e32a96eac20ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0bcfc0c9576a66b2cf59db833091db26cc10ac5bd6facbf286d045ed0e254d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0bcfc0c9576a66b2cf59db833091db26cc10ac5bd6facbf286d045ed0e254d7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d0bcfc0c9576a66b2cf59db833091db26cc10ac5bd6facbf286d045ed0e254d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "32db9d65a7640b8c51aef2b59b3c8f02c1ff9bc801bb1c25169a2a9e27eddf6a"
    sha256 cellar: :any_skip_relocation, ventura:       "32db9d65a7640b8c51aef2b59b3c8f02c1ff9bc801bb1c25169a2a9e27eddf6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9db3ef6c51bb900fd98d88c8f2a1971a7cfa3db4d5ddba914f1d98d67de346b5"
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
