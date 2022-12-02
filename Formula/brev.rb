class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://docs.brev.dev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.185.tar.gz"
  sha256 "2c400af17a27b2da6eb795a549b22f084197a58f82348000bf346cd6f65c8e7e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb9d6dfd43ee3784d990199381969de7e44a71f4fba868bb10c16668e6efde83"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcb1dacc70f06b00993723176e686efe324281cf27c3e764f295ff8c245b6631"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e19fd7ebc9e243781e766a38f6b8ce5764609c088b90a9e2a51c030ddfef051e"
    sha256 cellar: :any_skip_relocation, ventura:        "307df322915b4b23d9f50200ff7971a37528858c7510a822e43e3d7040595a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "b7c1bff3341f4897f904600fa976d537bdd0553acffbc53fcd309ff73a768edc"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fd5615a32ddb09417ba0f965781164dfd616a1f82ab661e0adcd87e9ab83c3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b458337295410c9da38dacc50acb097687cd07d588c4c0d21c5d208e64612232"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
