class Retire < Formula
  desc "Scanner detecting the use of JavaScript libraries with known vulnerabilities"
  homepage "https://retirejs.github.io/retire.js/"
  url "https://registry.npmjs.org/retire/-/retire-5.2.3.tgz"
  sha256 "169f8c6b70afd5fa9c6158604142f3f68114da27348b3270e77aea98e499991f"
  license "Apache-2.0"
  head "https://github.com/RetireJS/retire.js.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d0c71da3072b46ab9266ed91758304336b619e5fc6c1865ba4166ec62b532247"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/retire --version")

    system "git", "clone", "https://github.com/appsecco/dvna.git"
    output = shell_output("#{bin}/retire --path dvna 2>&1", 13)
    assert_match(/jquery (\d+(?:\.\d+)+) has known vulnerabilities/, output)
  end
end
