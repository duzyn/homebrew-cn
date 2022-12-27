class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/b0/be/778216e18bf50cf3d6b4fe77509700677de9ce01480a8a7dcbf3d778b586/solc-select-1.0.2.tar.gz"
  sha256 "ceba561d07680950c66831837fd7d686746c4ded46570aa4d6a96cd4fcaf94bc"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a55f962a9c03772c6a1d4edee6ce5a2352d66a3a01412c300293e18f6d2bd79d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bab938bd7e4a232378ffea6255dd48234eebec4465d4330198c8a098aba6693a"
    sha256 cellar: :any_skip_relocation, ventura:        "9aabde46ca59499ae107856ea8e33c0ef806aaa58da13772d1b7eba6c6dd19a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f539d2a03bd4ac11ff4ca3bd4decba2f6f9bd4b11b6a2e150c52663aaffb9486"
    sha256 cellar: :any_skip_relocation, big_sur:        "9878f267a773134af1a671cb3fdaa54accf767f32eddf68efc691905b8b46c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ceac03eb7e1ab4d3a4b1727b43d98290dfe68ffbffecf87b2489b43ee4fe3fb"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/11/e4/a8e8056a59c39f8c9ddd11d3bc3e1a67493abe746df727e531f66ecede9e/pycryptodome-3.15.0.tar.gz"
    sha256 "9135dddad504592bcc18b0d2d95ce86c3a5ea87ec6447ef25cfedea12d6018b8"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end
