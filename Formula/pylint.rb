class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/68/3a/1e61444eb8276ad962a7f300b6920b7ad391f4fbe551d34443f093a18899/pylint-2.15.9.tar.gz"
  sha256 "18783cca3cfee5b83c6c5d10b3cdb66c6594520ffae61890858fe8d932e1c6b4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27f3c9c0f8b863f1a6e8c9b19dcf2ca8daef1c1dd17b5f97df69d6edb4a14b03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33e6cdd8881ef2c2eb99e562bfef30f2705e19372941dacc3cf68f48e3beb693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63c710bbdd43664e661aea2f06607eb84f5085eba5037a8ea817fc7b27c50c19"
    sha256 cellar: :any_skip_relocation, ventura:        "0f760483121a48756a324530d12fe5b5f969efb943d72ef4f465d17f51bd6f1d"
    sha256 cellar: :any_skip_relocation, monterey:       "13d3712428b9c1356a63c36decfb6ee379aa5447b8ae1e6c5a82f792f317a87c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5ef313ba697fcdc49b8ac343cbca9c805917cd30d5cf05af4a8a0b84f1f5368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c97ad5fb2043653f63cb5ad1aa69d54ad63ef6992162203a197cbae3773486"
  end

  depends_on "isort"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/61/d0/e7cfca72ec7d6c5e0da725c003db99bb056e9b6c2f4ee6fae1145adf28a6/astroid-2.12.13.tar.gz"
    sha256 "1493fe8bd3dfd73dc35bd53c9d5b6e49ead98497c47b2307662556a5692d29d7"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/74/37/591f89e8a09ae4574391bdf8a5eecd34a3dbe545917333e625c9de9a66b0/lazy-object-proxy-1.8.0.tar.gz"
    sha256 "c219a00245af0f6fa4e95901ed28044544f50152840c5b6a3e7b2568db34d156"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ec/4c/9af851448e55c57b30a13a72580306e628c3b431d97fdae9e0b8d4fa3685/platformdirs-2.6.0.tar.gz"
    sha256 "b46ffafa316e6b83b47489d240ce17173f123a9b9c83282141c3daf26ad9ac2e"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
