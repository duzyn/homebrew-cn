require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.29.0.tgz"
  sha256 "358922f489f4c6cca00ed41bfc2f05336851fcd3aba0f9b48335585f5faa1a24"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d2f5d933ea57b78476604dafaee8121bf4020a2d9abd04fd139378b741a039d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d2f5d933ea57b78476604dafaee8121bf4020a2d9abd04fd139378b741a039d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d2f5d933ea57b78476604dafaee8121bf4020a2d9abd04fd139378b741a039d"
    sha256 cellar: :any_skip_relocation, ventura:        "3ee6aab298f62af3031a99b35b34a4777fa906de0322b94829cc0bf9ac86d7bb"
    sha256 cellar: :any_skip_relocation, monterey:       "3ee6aab298f62af3031a99b35b34a4777fa906de0322b94829cc0bf9ac86d7bb"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ee6aab298f62af3031a99b35b34a4777fa906de0322b94829cc0bf9ac86d7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d2f5d933ea57b78476604dafaee8121bf4020a2d9abd04fd139378b741a039d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
