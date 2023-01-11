require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.11.0.tgz"
  sha256 "7b30ef640270e7e613aa781d695fe15a61045bc5b597421523efb6614d446692"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "60b2d1f3bbf2421cd4fdc6d14a17fd4ca014cd56fc58e3681fb1cb6d6929fdfd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "60b2d1f3bbf2421cd4fdc6d14a17fd4ca014cd56fc58e3681fb1cb6d6929fdfd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "60b2d1f3bbf2421cd4fdc6d14a17fd4ca014cd56fc58e3681fb1cb6d6929fdfd"
    sha256 cellar: :any_skip_relocation, ventura:        "2b9f1ee851908f7b2540e73bb814a862bab98b88d82b63bd908c1715b65d281e"
    sha256 cellar: :any_skip_relocation, monterey:       "2b9f1ee851908f7b2540e73bb814a862bab98b88d82b63bd908c1715b65d281e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b9f1ee851908f7b2540e73bb814a862bab98b88d82b63bd908c1715b65d281e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaa04fa8684222f295d1e4a449ce3f220b96c2ee7fc1ccc50b38b12b1e3c982b"
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
