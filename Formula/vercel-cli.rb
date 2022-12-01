require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.6.0.tgz"
  sha256 "d12e9a13b690d84c40aeb9b442b6352778cdf64bcfc7469c77629c9c63e40907"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35ec7f304fe17849e154e9f2a58f3bf6bb180e27eaad4abf29d00329798fbbb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35ec7f304fe17849e154e9f2a58f3bf6bb180e27eaad4abf29d00329798fbbb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35ec7f304fe17849e154e9f2a58f3bf6bb180e27eaad4abf29d00329798fbbb1"
    sha256 cellar: :any_skip_relocation, ventura:        "b954b5670a69a19255f102aa148c2e5ec853831986925ecb53393dfa31d7135d"
    sha256 cellar: :any_skip_relocation, monterey:       "b954b5670a69a19255f102aa148c2e5ec853831986925ecb53393dfa31d7135d"
    sha256 cellar: :any_skip_relocation, big_sur:        "b954b5670a69a19255f102aa148c2e5ec853831986925ecb53393dfa31d7135d"
    sha256 cellar: :any_skip_relocation, catalina:       "b954b5670a69a19255f102aa148c2e5ec853831986925ecb53393dfa31d7135d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00125ceb3094da6624519eab6bace13a114c6b7855d0045da5dac1b3548bbc9a"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    dist_dir = libexec/"lib/node_modules/vercel/dist"
    rm_rf dist_dir/"term-size"

    if OS.mac?
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(dist_dir), dist_dir
    end
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
