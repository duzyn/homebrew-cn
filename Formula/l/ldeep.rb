class Ldeep < Formula
  include Language::Python::Virtualenv

  desc "LDAP enumeration utility"
  homepage "https://github.com/franc-pentest/ldeep"
  url "https://files.pythonhosted.org/packages/d1/23/0962bd0e24a16d028166528c719aae9cd9e1d23ac693644ab9ed5de19dd8/ldeep-1.0.39.tar.gz"
  sha256 "21e24e59232f700703843b7738838460af7e22268fbaf514deaf359e7d9e5070"
  license "MIT"
  head "https://github.com/franc-pentest/ldeep.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2df212370ad5a37814414b5fa6c2dadad91af1b79310d526e7a26d59d029f6b5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "843a9e3a88f0ea12bd670d7bb09ded8fa3e23e32dc2af0d3754f875b188004f8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc63a97e33422a514a641c17e0107cfb918f7aff105afa47313a397e387edffa"
    sha256 cellar: :any_skip_relocation, sonoma:         "c463a95effbc1ceae9f99d0d8b0fad9ea962bd50aa3f5e9253e48c874efbd549"
    sha256 cellar: :any_skip_relocation, ventura:        "a116f85f822e05af0ee4ea8eeaacbe7397170f79423db18e477090e2a06774b3"
    sha256 cellar: :any_skip_relocation, monterey:       "170658d90efafaf1c90ccc9f787b9b481281923b809585dd98499282a23c4e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ce0eef01545c69ba2d8afd9c18be677d9f9cdc629fb843fe4bbd0f77f4552e2"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python-cryptography"
  depends_on "python@3.11"
  depends_on "six"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/de/cf/d547feed25b5244fcb9392e288ff9fdc3280b10260362fc45d37a798a6ee/asn1crypto-1.5.1.tar.gz"
    sha256 "13ae38502be632115abf8a24cbe5f4da52e3b5231990aff31123c805306ccb9c"
  end

  resource "commandparse" do
    url "https://files.pythonhosted.org/packages/79/6b/6f1879101e405e2a5c7d352b340bc97d1936f8d54a8934ae32aac1828e50/commandparse-1.1.2.tar.gz"
    sha256 "4bd7bdd01b52eaa32316d6149a00b4c3820a40ff2ad62476b46aaae65dbe9faa"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/65/2d/372a20e52a87b2ba0160997575809806111a72e18aa92738daccceb8d2b9/dnspython-2.4.2.tar.gz"
    sha256 "8dcfae8c7460a2f84b4072e26f1c9f4101ca20c071649cb7c34e8b6a93d58984"
  end

  resource "gssapi" do
    url "https://files.pythonhosted.org/packages/13/e7/dd88180cfcf243be62308707cc2f5dae4c726c68f30b9367931c794fda16/gssapi-1.8.3.tar.gz"
    sha256 "aa3c8d0b1526f52559552bb2c9d2d6be013d76a8e5db00b39a1db5727e93b0b0"
  end

  resource "ldap3" do
    url "https://files.pythonhosted.org/packages/43/ac/96bd5464e3edbc61595d0d69989f5d9969ae411866427b2500a8e5b812c0/ldap3-2.9.1.tar.gz"
    sha256 "f3e7fc4718e3f09dda568b57100095e0ce58633bcabbed8667ce3f8fbaa4229f"
  end

  resource "oscrypto" do
    url "https://files.pythonhosted.org/packages/06/81/a7654e654a4b30eda06ef9ad8c1b45d1534bfd10b5c045d0c0f6b16fecd2/oscrypto-1.3.0.tar.gz"
    sha256 "6f5fef59cb5b3708321db7cca56aed8ad7e662853351e7991fcf60ec606d47a4"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "pycryptodomex" do
    url "https://files.pythonhosted.org/packages/14/c9/09d5df04c9f29ae1b49d0e34c9934646b53bb2131a55e8ed2a0d447c7c53/pycryptodomex-3.19.0.tar.gz"
    sha256 "af83a554b3f077564229865c45af0791be008ac6469ef0098152139e6bd4b5b6"
  end

  resource "termcolor" do
    url "https://files.pythonhosted.org/packages/b8/85/147a0529b4e80b6b9d021ca8db3a820fcac53ec7374b87073d004aaf444c/termcolor-2.3.0.tar.gz"
    sha256 "b5b08f68937f138fe92f6c089b99f1e2da0ae56c52b78bf7075fd95420fd9a5a"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/62/06/d5604a70d160f6a6ca5fd2ba25597c24abd5c5ca5f437263d177ac242308/tqdm-4.66.1.tar.gz"
    sha256 "d88e651f9db8d8551a62556d3cff9e3034274ca5d66e93197cf2490e2dcb69c7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/ldeep ldap -d brew.ad -s ldap://127.0.0.1:389 enum_users test 2>&1", 1)
    assert_match "[!] Unable to open connection with ldap://127.0.0.1:389", output
  end
end