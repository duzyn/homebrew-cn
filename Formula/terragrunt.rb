class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.42.5.tar.gz"
  sha256 "f8526bc6c0daceb081c3f16bf0d83411aa070b65c25ff124b4ce5cc397ec6080"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ef4d707a40797248d77171331dc5c7554dc078a1667acbcb5d828960e8e55a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5556108dac6b7e4c01e37a31089ef64d55766294548b1d6e67b948790ad92091"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9d704ed2e292ca5d7dc78fd4a3a5707a0b76f43a22887213f8e89714c888967a"
    sha256 cellar: :any_skip_relocation, ventura:        "0ae0bbfc0d962a3d50f4b06830f48e8dd1829272d5a4941c958c07ff747e4f03"
    sha256 cellar: :any_skip_relocation, monterey:       "a1231927c2da4f26692de0e2cb0a9e8b61c24a8a873991b33d941672aa0e23b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "3e519814b0f044cb3e9d576e09c28d7926bb8cc3b73bf3a5b7a4829f256f5c0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "010c66ad359a8373657d68f5a0f17a9d5976e4e064224078de1b0ac1cff04041"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
