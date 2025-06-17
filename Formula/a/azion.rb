class Azion < Formula
  desc "CLI for the Azion service"
  homepage "https://github.com/aziontech/azion"
  url "https://mirror.ghproxy.com/https://github.com/aziontech/azion/archive/refs/tags/3.4.0.tar.gz"
  sha256 "3481af7619fe80658d002aa1f39493c973089e5312a2b7ef5a4aa8316e96e661"
  license "MIT"
  head "https://github.com/aziontech/azion.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33a208cf6750cea6c691e785154b700ff788f805c8c9acc279df0be8331c07f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33a208cf6750cea6c691e785154b700ff788f805c8c9acc279df0be8331c07f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "33a208cf6750cea6c691e785154b700ff788f805c8c9acc279df0be8331c07f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "abbd41465a07bb9f75da6ab96af425aaf7f0cb25672e6af6d0be52a6c6b03320"
    sha256 cellar: :any_skip_relocation, ventura:       "abbd41465a07bb9f75da6ab96af425aaf7f0cb25672e6af6d0be52a6c6b03320"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a11dd7bf4711bcd4710b2fc511a4e4834287d89bc5869de01c59c4fabd13e385"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/aziontech/azion-cli/pkg/cmd/version.BinVersion=#{version}
      -X github.com/aziontech/azion-cli/pkg/constants.StorageApiURL=https://api.azion.com
      -X github.com/aziontech/azion-cli/pkg/constants.AuthURL=https://sso.azion.com/api
      -X github.com/aziontech/azion-cli/pkg/constants.ApiURL=https://api.azionapi.net
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azion"

    generate_completions_from_executable(bin/"azion", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azion --version")
    assert_match "Failed to build your resource", shell_output("#{bin}/azion build --yes 2>&1", 1)
  end
end
