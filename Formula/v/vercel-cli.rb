class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-50.10.2.tgz"
  sha256 "4fd657c0426e820549f764bf107d4a4b5e643f6d4da9c806bd2489093ffc77f7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ecf00b8dbbf7696ebc8da724cc34bc06864868fac39b75157ad842d933ec6c86"
    sha256 cellar: :any,                 arm64_sequoia: "a7f3c62c8d10e4058716cd9d8589126d6fc6cc501d029f2d7285399ec53592aa"
    sha256 cellar: :any,                 arm64_sonoma:  "a7f3c62c8d10e4058716cd9d8589126d6fc6cc501d029f2d7285399ec53592aa"
    sha256 cellar: :any,                 sonoma:        "2b2a7795d13c807fee17da8e9155d80fbd2146f969dd4610f61a1254eb15da81"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ee84cffa050257e03b1692bddcca9da33cb6539af978364f42a08883f7bf3b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "13ab2b243e319449011492d789be767270d2ab104790915382c4750bdb538312"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "${await getUpdateCommand()}",
                               "brew upgrade vercel-cli"

    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| rm_r(dir) if dir.basename.to_s != "#{os}-#{arch}" }

    deuniversalize_machos node_modules/"fsevents/fsevents.node" if OS.mac?
  end

  test do
    system bin/"vercel", "init", "jekyll"
    assert_path_exists testpath/"jekyll/_config.yml", "_config.yml must exist"
    assert_path_exists testpath/"jekyll/README.md", "README.md must exist"
  end
end
