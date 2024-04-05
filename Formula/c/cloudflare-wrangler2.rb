require "language/node"

class CloudflareWrangler2 < Formula
  include Language::Node::Shebang

  desc "CLI tool for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workers-sdk"
  url "https://registry.npmjs.org/wrangler/-/wrangler-3.47.0.tgz"
  sha256 "d688d5085162f16ffbbf4e7c7679bd21bbea57fa6af6ab0e1df92d4a576dcb27"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b70a21a522698882b6d310c0d70668ae99a0ecc22fee0f14c2043976b1336477"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b70a21a522698882b6d310c0d70668ae99a0ecc22fee0f14c2043976b1336477"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b70a21a522698882b6d310c0d70668ae99a0ecc22fee0f14c2043976b1336477"
    sha256 cellar: :any_skip_relocation, sonoma:         "02a7c376c740343ad14539c720a6be1236fb51d655c9c3359fca8231c150c525"
    sha256 cellar: :any_skip_relocation, ventura:        "02a7c376c740343ad14539c720a6be1236fb51d655c9c3359fca8231c150c525"
    sha256 cellar: :any_skip_relocation, monterey:       "02a7c376c740343ad14539c720a6be1236fb51d655c9c3359fca8231c150c525"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d895cf33669ac4b0128b58ceeb21de8cbaa8686c8372d2ad42420b4acd10e8c"
  end

  depends_on "node"

  conflicts_with "cloudflare-wrangler", because: "both install `wrangler` binaries"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    rewrite_shebang detected_node_shebang, *Dir["#{libexec}/lib/node_modules/**/*"]
    bin.install_symlink Dir["#{libexec}/bin/wrangler*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wrangler -v")
    assert_match "Required Worker name missing", shell_output("#{bin}/wrangler secret list 2>&1", 1)
  end
end
