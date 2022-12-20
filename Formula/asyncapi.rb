require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.27.1.tgz"
  sha256 "0cc65510e77b1b5ee07c329c3cabc14b5bab17f9a95cfa8ddaf32ffb2a208f50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1304ed06b342586d716746ecb5606fdb6c2315d046c685f32803f406b7c44497"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1304ed06b342586d716746ecb5606fdb6c2315d046c685f32803f406b7c44497"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1304ed06b342586d716746ecb5606fdb6c2315d046c685f32803f406b7c44497"
    sha256 cellar: :any_skip_relocation, ventura:        "d8757b06e0fa3e9018e29d54c48ba143cb18fd36cd9364767ab3593b9d4137f7"
    sha256 cellar: :any_skip_relocation, monterey:       "d8757b06e0fa3e9018e29d54c48ba143cb18fd36cd9364767ab3593b9d4137f7"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8757b06e0fa3e9018e29d54c48ba143cb18fd36cd9364767ab3593b9d4137f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f570fc32590368e21ce0d6971a2d9bc3ea5c5b42c884f368c81c64b299e4ebf"
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
