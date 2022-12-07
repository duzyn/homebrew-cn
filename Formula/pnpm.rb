class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.18.1.tgz"
  sha256 "0206fea9bca3e359ed32cd7b489a02d6f9eb5892c88b875f46150517f723613b"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7c43a03c6bad3af67bb390736f6e9e459c0974b8df0f8f1c27a493cc52da1444"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7c43a03c6bad3af67bb390736f6e9e459c0974b8df0f8f1c27a493cc52da1444"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7c43a03c6bad3af67bb390736f6e9e459c0974b8df0f8f1c27a493cc52da1444"
    sha256 cellar: :any_skip_relocation, ventura:        "8268d35ed0007f9d276df8bb69f7d153c13cbb94e735797e363128856544ec7a"
    sha256 cellar: :any_skip_relocation, monterey:       "8268d35ed0007f9d276df8bb69f7d153c13cbb94e735797e363128856544ec7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fa17c3fb65ff5c7ef42c949591f724fb56eab4b0e42b66d2f976aa668276e5bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c43a03c6bad3af67bb390736f6e9e459c0974b8df0f8f1c27a493cc52da1444"
  end

  depends_on "node" => :test

  conflicts_with "corepack", because: "both installs `pnpm` and `pnpx` binaries"

  def install
    libexec.install buildpath.glob("*")
    bin.install_symlink "#{libexec}/bin/pnpm.cjs" => "pnpm"
    bin.install_symlink "#{libexec}/bin/pnpx.cjs" => "pnpx"
  end

  def caveats
    <<~EOS
      pnpm requires a Node installation to function. You can install one with:
        brew install node
    EOS
  end

  test do
    system "#{bin}/pnpm", "init"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
