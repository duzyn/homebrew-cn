class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.3.12.tgz"
  sha256 "3713278f2a1badee5686ccefa54322d841ccfc259233eeef121db324ac08458e"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "99b4055aa5be12eb26b171288d59a5f22e800edca2e082d01f85e3329c25f33e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99b4055aa5be12eb26b171288d59a5f22e800edca2e082d01f85e3329c25f33e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "99b4055aa5be12eb26b171288d59a5f22e800edca2e082d01f85e3329c25f33e"
    sha256 cellar: :any_skip_relocation, sonoma:        "df841f2781fb87872481bdf9d61052724759fbd87dff0c7b2897548001cfdf54"
    sha256 cellar: :any_skip_relocation, ventura:       "df841f2781fb87872481bdf9d61052724759fbd87dff0c7b2897548001cfdf54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99b4055aa5be12eb26b171288d59a5f22e800edca2e082d01f85e3329c25f33e"
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
