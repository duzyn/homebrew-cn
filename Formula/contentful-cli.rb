require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.16.10.tgz"
  sha256 "ae2bbbd1c4d7b8d4a042bbc45153b16156c621031bcb57a9a17aef45222f4249"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae5ec195731791dfbb40e6c8da7bd9beb4e817305804792a2282df5464cba116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae5ec195731791dfbb40e6c8da7bd9beb4e817305804792a2282df5464cba116"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae5ec195731791dfbb40e6c8da7bd9beb4e817305804792a2282df5464cba116"
    sha256 cellar: :any_skip_relocation, ventura:        "f69551f6a0e161c1a7fdc981da2673f920604d86aa996df9d42e8f5063422cf3"
    sha256 cellar: :any_skip_relocation, monterey:       "f69551f6a0e161c1a7fdc981da2673f920604d86aa996df9d42e8f5063422cf3"
    sha256 cellar: :any_skip_relocation, big_sur:        "f69551f6a0e161c1a7fdc981da2673f920604d86aa996df9d42e8f5063422cf3"
    sha256 cellar: :any_skip_relocation, catalina:       "f69551f6a0e161c1a7fdc981da2673f920604d86aa996df9d42e8f5063422cf3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae5ec195731791dfbb40e6c8da7bd9beb4e817305804792a2282df5464cba116"
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
