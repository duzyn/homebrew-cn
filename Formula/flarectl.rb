class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.57.0.tar.gz"
  sha256 "9c68ba1c980ac12b3cd3761b0e2821f14b9fccb387bbd37f9aa697ac004b1ba4"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d247d9c806568ca1ba6cbcdb845d3aa71d12836819314485a29b081155ce5b99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f493f688bec79d08580b247c6bf086f21542a8f47d68f694424f7f6d5023084"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3ac19315915ac4fbf7a9dde8f74b8ce027f891701aae888725677d310d6d356b"
    sha256 cellar: :any_skip_relocation, ventura:        "821befc9a37ffe901a67f37fec69189c932119e2a15d922fd4936e48ff6d2245"
    sha256 cellar: :any_skip_relocation, monterey:       "f7d3c7c68a2f19b2e63b482cb5cd000bf9c87a19b6453337f3946ae913d4450f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5ee34d395b4736a77fd15a6c1a298aa6fb756ae9c77972683eff6ae99770c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9805f3d51e6ce6af0dbf6e3774d6d4d47c6610f5e5e718456cc8e3b9bf1f068"
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
