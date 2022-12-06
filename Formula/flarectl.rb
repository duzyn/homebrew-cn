class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.56.0.tar.gz"
  sha256 "c131e9e1a68d33cf6940ef6ab68f7ff84bca54c3c2eacac2b47d9df1069e1258"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00e4f95854c73b890bceeb8266cf19e3219f835ec7fdcdeba885ad4dc79ea99e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8304c651e5fdcb6b4a92cab34259fadfe4ec23ad2fffc44cf986f7a302f9e32f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d3a234787e889a21afb564fa5c88fe6299e6d505bf8f858425563019f9b03f5c"
    sha256 cellar: :any_skip_relocation, ventura:        "a662b047baa8bdd1bb6bd356086a434575acec16947e7470ba186d84ed2644da"
    sha256 cellar: :any_skip_relocation, monterey:       "ad3c8f16b0990e79d6754753f84492e3a0069684757c62a24f9c0763cf2ef488"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf0beea97a116ad4c63f085a9a4c2107b8836b5349fd461e77b6ff2fa65788de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "189f8da61b6ed54f7a7afc27b8520cf099ee3e30184b7738bf483d0064fa1953"
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
