require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.27.0.tgz"
  sha256 "41638ad8de4dd83bb7b6ed43baf2af93e9413e8de07a9e33a6cda38e3f892447"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a61e8ee961a7564b0915e360f3d0bc6ebf73c598d8017e67157d5c569429c554"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a61e8ee961a7564b0915e360f3d0bc6ebf73c598d8017e67157d5c569429c554"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a61e8ee961a7564b0915e360f3d0bc6ebf73c598d8017e67157d5c569429c554"
    sha256 cellar: :any_skip_relocation, ventura:        "cc12c78c5a0d64f4245e5beab1f7fa4bc67ac43498b19dc41e6fd2df284958df"
    sha256 cellar: :any_skip_relocation, monterey:       "cc12c78c5a0d64f4245e5beab1f7fa4bc67ac43498b19dc41e6fd2df284958df"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc12c78c5a0d64f4245e5beab1f7fa4bc67ac43498b19dc41e6fd2df284958df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9cbb2ab9f52c6b9a62756ee17d23e90e5a11d11ad38151e968ffd713e38bfd34"
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
