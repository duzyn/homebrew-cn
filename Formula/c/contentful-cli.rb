class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.6.1.tgz"
  sha256 "06f49cfe01c2e9559bf7d6656341f6460ee08c232a22ae65bf272ab048dd2a61"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a7fc343a73ba664269b0ed4cfe0558bd32658c39a56f0e663848b4755ae38310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a7fc343a73ba664269b0ed4cfe0558bd32658c39a56f0e663848b4755ae38310"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a7fc343a73ba664269b0ed4cfe0558bd32658c39a56f0e663848b4755ae38310"
    sha256 cellar: :any_skip_relocation, sonoma:        "088658fd444d46e077bd383860a0ccdb2f2ff2ac77065891ee6c2cd9ba78cec8"
    sha256 cellar: :any_skip_relocation, ventura:       "088658fd444d46e077bd383860a0ccdb2f2ff2ac77065891ee6c2cd9ba78cec8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b384b9a7940bc61fc608357fb8b117ed7bc42719c0511ca1afacc61c6311d97b"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
