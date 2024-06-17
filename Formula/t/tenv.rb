class Tenv < Formula
  desc "OpenTofu / Terraform / Terragrunt / Atmos version manager"
  homepage "https://tofuutils.github.io/tenv/"
  url "https://mirror.ghproxy.com/https://github.com/tofuutils/tenv/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "29e5e337bb8f6a8113744e4a338090fd5b213fe8e06f9fa02725034810b7fbfb"
  license "Apache-2.0"
  head "https://github.com/tofuutils/tenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3f2fee7394568aa397c04da590e22c3cae8656ef4b45feba4dc406bd417bee0d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3f2fee7394568aa397c04da590e22c3cae8656ef4b45feba4dc406bd417bee0d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f2fee7394568aa397c04da590e22c3cae8656ef4b45feba4dc406bd417bee0d"
    sha256 cellar: :any_skip_relocation, sonoma:         "32cdc4b30e20a397cc4ecd45dc1ec9a97d8ed782cd50e67a508d3a81e13693e2"
    sha256 cellar: :any_skip_relocation, ventura:        "32cdc4b30e20a397cc4ecd45dc1ec9a97d8ed782cd50e67a508d3a81e13693e2"
    sha256 cellar: :any_skip_relocation, monterey:       "32cdc4b30e20a397cc4ecd45dc1ec9a97d8ed782cd50e67a508d3a81e13693e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc1783fecfcee83c7de8bc167150762980b8c3745ba9a044be0a27dcf3e1f297"
  end

  depends_on "go" => :build

  conflicts_with "opentofu", because: "both install tofu binary"
  conflicts_with "terraform", because: "both install terraform binary"
  conflicts_with "terragrunt", because: "both install terragrunt binary"
  conflicts_with "atmos", because: "both install atmos binary"
  conflicts_with "tfenv", because: "tfenv symlinks terraform binaries"
  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-s -w -X main.version=#{version}"
    %w[tenv terraform terragrunt tf tofu atmos].each do |f|
      system "go", "build", *std_go_args(ldflags:, output: bin/f), "./cmd/#{f}"
    end
    generate_completions_from_executable(bin/"tenv", "completion")
  end

  test do
    assert_match "1.6.2", shell_output("#{bin}/tenv tofu list-remote")
    assert_match version.to_s, shell_output("#{bin}/tenv --version")
  end
end
