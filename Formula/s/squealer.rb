class Squealer < Formula
  desc "Scans Git repositories or filesystems for secrets in commit histories"
  homepage "https://github.com/owenrumney/squealer"
  url "https://mirror.ghproxy.com/https://github.com/owenrumney/squealer/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "7b13a6d5d52d2cf54c13b0f25d48b8c5712e5a0d2e9cda7122ecd685f565c76e"
  license "Unlicense"
  head "https://github.com/owenrumney/squealer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f23e33f95306ea726f02a555af2de2518e4104df8c65b1b4c2c1bbe5c8d62ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f23e33f95306ea726f02a555af2de2518e4104df8c65b1b4c2c1bbe5c8d62ec0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f23e33f95306ea726f02a555af2de2518e4104df8c65b1b4c2c1bbe5c8d62ec0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5861ae33901906761a6267700c647c91b53dd0db6271f4a5f4bb31c56ea55b53"
    sha256 cellar: :any_skip_relocation, ventura:       "5861ae33901906761a6267700c647c91b53dd0db6271f4a5f4bb31c56ea55b53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ddbce2e011a66b07005de46ca3ca3941ed9c7ef3abd2a2d79d395643f3b69652"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/owenrumney/squealer/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/squealer"
  end

  test do
    system "git", "clone", "https://github.com/owenrumney/woopsie.git"
    output = shell_output("#{bin}/squealer woopsie", 1)
    assert_match "-----BEGIN OPENSSH PRIVATE KEY-----", output
  end
end
