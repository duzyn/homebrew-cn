require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.16.15.tgz"
  sha256 "0af8337672216506f1ef447ae1b43bf364c5dbaf182b45023e9968e4b18f4528"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d092458b782420194a5ba12493ecc60ed250d5045f37e737b194bf06a4d02dbb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d092458b782420194a5ba12493ecc60ed250d5045f37e737b194bf06a4d02dbb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d092458b782420194a5ba12493ecc60ed250d5045f37e737b194bf06a4d02dbb"
    sha256 cellar: :any_skip_relocation, ventura:        "5b28b11feec2ad063604009897970a9784fc8fde21d0e5a6fb9f5836cebef9fe"
    sha256 cellar: :any_skip_relocation, monterey:       "5b28b11feec2ad063604009897970a9784fc8fde21d0e5a6fb9f5836cebef9fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b28b11feec2ad063604009897970a9784fc8fde21d0e5a6fb9f5836cebef9fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d092458b782420194a5ba12493ecc60ed250d5045f37e737b194bf06a4d02dbb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
