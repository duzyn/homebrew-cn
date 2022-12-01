require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.26.5.tgz"
  sha256 "9b6bc307411b329dcdd4384e17180fad2c613ecb5be1872858c7a1e61841fe55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51b736204a056a3ba935b7d374737299250e126b18c5a9dc5e73345e781228db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51b736204a056a3ba935b7d374737299250e126b18c5a9dc5e73345e781228db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "51b736204a056a3ba935b7d374737299250e126b18c5a9dc5e73345e781228db"
    sha256 cellar: :any_skip_relocation, ventura:        "a2b520ca86b594f0940e08343bffc13297facbf7cf68ab4c7b5a111b832f8696"
    sha256 cellar: :any_skip_relocation, monterey:       "c9f82a51ae4f8970d9d234ad4ebccf5b47ccd1a0cf8274e6f4e44f3860bc499a"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9f82a51ae4f8970d9d234ad4ebccf5b47ccd1a0cf8274e6f4e44f3860bc499a"
    sha256 cellar: :any_skip_relocation, catalina:       "c9f82a51ae4f8970d9d234ad4ebccf5b47ccd1a0cf8274e6f4e44f3860bc499a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "945736b195487d26d18aada0757f032f5ec318f109d79d303bbf01d9dde60535"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
