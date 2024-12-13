class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://mirror.ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.69.11.tar.gz"
  sha256 "8cd8d5d67e0280b58e45b9e8717a2317098c5d6b61ce928f4ae1d81db7b4c016"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "663b5f47e75947a9f84f73cd9d153fe90e66fbd6958b0dea07d6b3823cd8f5b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "663b5f47e75947a9f84f73cd9d153fe90e66fbd6958b0dea07d6b3823cd8f5b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "663b5f47e75947a9f84f73cd9d153fe90e66fbd6958b0dea07d6b3823cd8f5b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ba162c19d0e49feb755057c7c907adc89eb2ff5959db9d29f02afd83143d692"
    sha256 cellar: :any_skip_relocation, ventura:       "1ba162c19d0e49feb755057c7c907adc89eb2ff5959db9d29f02afd83143d692"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a8641ad5af3f2b530f8d5acf3cae7f3ea5ce2f75764340e84de55ae68e6ebdd"
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
