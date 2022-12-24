class Flarectl < Formula
  desc "CLI application for interacting with a Cloudflare account"
  homepage "https://github.com/cloudflare/cloudflare-go/tree/master/cmd/flarectl"
  url "https://github.com/cloudflare/cloudflare-go/archive/v0.57.1.tar.gz"
  sha256 "6a93ba56f6f51481f73451b8e11f941e08c40fff942680d85cb94939cf1d9447"
  license "BSD-3-Clause"
  head "https://github.com/cloudflare/cloudflare-go.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "524f690031787a99bc1c6f2cb2bd4bc1f5880f9ab4920a526c88457ce4c32e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b51405857bbcdee536a41d112110fdbcd79c5f5430fefc0f88660dbb833424e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1923c8007e143a772b7dd03b4bea39be08af51d7f88ef99576ad780b2ba2cf79"
    sha256 cellar: :any_skip_relocation, ventura:        "0fb3bda642e29c21a55725cbebe66e9714df74e76b981ea2e24e585fa3179519"
    sha256 cellar: :any_skip_relocation, monterey:       "5a9ab6c772afbd81dbe32fa77b02dbbcc644a9be6b6fac728d0851f11148c7c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "6ba58da40682b54592b69099cfefa191b96c91383846c80db2a8e264f9e37a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cda6cf4ec53a3ed36aec36f47834fe7d693538bf2bf0a83cd0d27c05a8f29e9b"
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
