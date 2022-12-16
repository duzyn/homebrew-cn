class Terramate < Formula
  desc "Managing Terraform stacks with change detections and code generations"
  homepage "https://github.com/mineiros-io/terramate"
  url "https://github.com/mineiros-io/terramate/archive/refs/tags/v0.2.5.tar.gz"
  sha256 "0db5d203d3bec2f2d7989d62e1cb173f0ca61687271ac91cc1d3ea79776c3e6b"
  license "Apache-2.0"
  head "https://github.com/mineiros-io/terramate.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fb25cee942ddae20045a8a5c51793839586d4774bffd04baf5effcdc43d9baf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c553ea704fc0f94c064b89e6e88969ac1b85cf101f99b24e32525d595ca1632"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a4a3afddab3066e530f51572e144e7710a5486ef7b66d69ce60472c5b41c1a0"
    sha256 cellar: :any_skip_relocation, ventura:        "5f0123f164d1062dca2f4e1817e6217ac829b10eb230b81662010d8c78ef4188"
    sha256 cellar: :any_skip_relocation, monterey:       "1ad07b1796a1b5f812cd23e1d8e8c319d45d894ae0397b8d139a6303fc2e3ea7"
    sha256 cellar: :any_skip_relocation, big_sur:        "c99194a7e8a129a8b2a4dcd850f373ff795df8cf27e75cf63664bd828ac1d504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22b30c5128c79150b42958b444650a367bd738443e66229d3b19938a7bf50a09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/terramate"
  end

  test do
    assert_match "project root not found", shell_output("#{bin}/terramate list 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}/terramate version")
  end
end
