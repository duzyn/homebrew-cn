class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-7.21.0.tgz"
  sha256 "55c2246a81d433295fb0c701a349b3254de95348976f02e5acef031fc1045111"
  license "MIT"

  livecheck do
    url "https://registry.npmjs.org/pnpm/latest"
    regex(/["']version["']:\s*?["']([^"']+)["']/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "437df8c9db59a88e1a6681a59373e6b9786b46a8ebf5c256ee375e2deab427f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "437df8c9db59a88e1a6681a59373e6b9786b46a8ebf5c256ee375e2deab427f3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "437df8c9db59a88e1a6681a59373e6b9786b46a8ebf5c256ee375e2deab427f3"
    sha256 cellar: :any_skip_relocation, ventura:        "da1ce92c6ee2d8dfc411630e046e9f400b01642027456f3388c61be8a3c352cc"
    sha256 cellar: :any_skip_relocation, monterey:       "da1ce92c6ee2d8dfc411630e046e9f400b01642027456f3388c61be8a3c352cc"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e4564422310641a8ce0d51b9ea0e9b4996b3eda28161a57742c5acbef10812e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "437df8c9db59a88e1a6681a59373e6b9786b46a8ebf5c256ee375e2deab427f3"
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
