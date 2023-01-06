class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.58.1.tar.gz"
  sha256 "819ae94e23911aabdb5d6b42c4b489b73d3710c6308fbeb3794e11779e86f5cf"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c059681f1c020fc5f47b404d85eb5ba8881b39583f6f85e4b314fec2ef380ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2532ab87a99b7d02371aa97a293b15c54ff928d1065cd7d0f0f945df0c317457"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ede110d817254e64812d51eb7fcdff3f9e1aaeeb4f84ab03c12783fba704062f"
    sha256 cellar: :any_skip_relocation, ventura:        "0cf621603bcc476a4072d8bc0c146cf0c1b4fc0a651e1b6dfbbdc449e5396a7d"
    sha256 cellar: :any_skip_relocation, monterey:       "1ad347865c6fda468667a89e85aa245a20185919e309b8fe48742c23032a5089"
    sha256 cellar: :any_skip_relocation, big_sur:        "11a7fd8eb118a1b4fe04a3bb6ae5076070337d0ddb3f94c253af5f38330ef15f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "285dc9362da17e7a48187cad56fb4cd636a97de12137e495ce362fb036d8f978"
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
