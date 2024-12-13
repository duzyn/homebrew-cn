class Promptfoo < Formula
  desc "Test your LLM app locally"
  homepage "https://promptfoo.dev/"
  url "https://registry.npmjs.org/promptfoo/-/promptfoo-0.100.6.tgz"
  sha256 "e5ad4978b5522db8672daf78772e7172d4d432fdd652e94d9c9bb19b75ff7b75"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "336a3dd4c25b62c806c7dcd4d5f2bcda0516dbd4b15a0b4864f5346c4cb98710"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57671a576d8b96df72be7ed28b3ec75d558c94d4974a44db2e586dace8927d41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "496d179fe5c73686db11cb0ee1ffccabf2bdafb3f1866177f37eee091f4be81e"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1a8c01bc3f6963d9eac3f3b80d3f36e4a880824707fbd54c3efcb14b55a04e"
    sha256 cellar: :any_skip_relocation, ventura:       "956d6457e4167704f5a1d0443e12f822e7a4feb413c526bfaf3fec261a783a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "257772f867f8cc800ca3f1c7acd0b4658923cd2f7a4a23e4156b290941278eed"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["PROMPTFOO_DISABLE_TELEMETRY"] = "1"

    system bin/"promptfoo", "init", "--no-interactive"
    assert_predicate testpath/"promptfooconfig.yaml", :exist?
    assert_match "description: \"My eval\"", (testpath/"promptfooconfig.yaml").read

    assert_match version.to_s, shell_output("#{bin}/promptfoo --version")
  end
end
