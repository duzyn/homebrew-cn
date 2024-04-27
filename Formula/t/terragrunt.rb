class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://mirror.ghproxy.com/https://github.com/gruntwork-io/terragrunt/archive/refs/tags/v0.57.11.tar.gz"
  sha256 "6c08b8e41f9e1f5ca44f51657110417c6362e31a31dca46693f0b9b76ad1d8fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "67fb6ab0af61d4cbbb63ae8e78dc1ecbb3fe286499de966101b7f80e846eb725"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70ca8638afc28979c95ef2ca2ebcc93e0906d1013c1e2283983536d420ceaed3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8155e72191015fa047e8b34407eb25259bc2f079ad0b7c77368ce22bcb2668e1"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a497410c7196b0843483a9e566bb385e005577ae4159e34975738e9f0404dd6"
    sha256 cellar: :any_skip_relocation, ventura:        "e7c62ca7916058b97e44b784cb8f60ea505dfcdb1067532b26a2d00f65fb83b3"
    sha256 cellar: :any_skip_relocation, monterey:       "f1a2bd6e719ce36784701cb54d3534add3b0c64ce02eb98811097476f505a210"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ff69c08d544d21bd3f71c75e376ba1d5aeb7f948ac694cc7b309c5a267045f6"
  end

  depends_on "go" => :build

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
