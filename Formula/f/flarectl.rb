class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://mirror.ghproxy.com/https://github.com/cloudflare/cloudflare-go/archive/refs/tags/v0.105.0.tar.gz"
  sha256 "bd46cbf1d779cfb583c2485ea002955d5b118a9b07d197e12229876b68ce4a22"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  livecheck do
    url :stable
    # track v0.x releases
    regex(/^v?(0(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fecdf341bbb9caecabf0baae5b5504dda42e3651a3e63842ec97e000771e9fab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fecdf341bbb9caecabf0baae5b5504dda42e3651a3e63842ec97e000771e9fab"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fecdf341bbb9caecabf0baae5b5504dda42e3651a3e63842ec97e000771e9fab"
    sha256 cellar: :any_skip_relocation, sonoma:        "962cb19220bcaa0692e67a4b95c3942737e448ea4c5d53f78670376bc51a4b87"
    sha256 cellar: :any_skip_relocation, ventura:       "962cb19220bcaa0692e67a4b95c3942737e448ea4c5d53f78670376bc51a4b87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "58d0b31c1d2268ccd42b8128a8c10f7c79d0e6a1b24c1912d5003f333fbf3b09"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/flarectl"
  end

  test do
    ENV["CF_API_TOKEN"] = "invalid"
    assert_match "Invalid request headers (6003)", shell_output("#{bin}/flarectl u i", 1)
  end
end
