class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/pylint-dev/pylint"
  url "https://files.pythonhosted.org/packages/dc/38/bd0af116fb2153b3efac3ac0b82953d4ac690b020c28f32d5fa38b979ee1/pylint-3.3.0.tar.gz"
  sha256 "c685fe3c061ee5fb0ce7c29436174ab84a2f525fce2a268b1986e921e083fe22"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "695440ad875fa54652a645bcf24c76b0bd990aa48addcde157c646adc6ba84eb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "695440ad875fa54652a645bcf24c76b0bd990aa48addcde157c646adc6ba84eb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "695440ad875fa54652a645bcf24c76b0bd990aa48addcde157c646adc6ba84eb"
    sha256 cellar: :any_skip_relocation, sonoma:        "1cf7d4b9fcaea35aa60dd82fa6f824b75d224f13d74d69c820532999b23f42f1"
    sha256 cellar: :any_skip_relocation, ventura:       "1cf7d4b9fcaea35aa60dd82fa6f824b75d224f13d74d69c820532999b23f42f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb73bb0df86cca9ac8a3cdb018ef040c4e9a0448c5a6e3645f833343695b6311"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/fe/ba/1b405d964cb37060f331029fa6baedb4f39832c65e270aa435d9ea704c08/astroid-3.3.3.tar.gz"
    sha256 "63f8c5370d9bad8294163c87b2d440a7fdf546be6c72bbeac0549c93244dbd72"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/17/4d/ac7ffa80c69ea1df30a8aa11b3578692a5118e7cd1aa157e3ef73b092d15/dill-0.3.8.tar.gz"
    sha256 "3ebe3c479ad625c4553aca177444d89b486b1d84982eeacded644afc0cf797ca"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/87/f9/c1eb8635a24e87ade2efce21e3ce8cd6b8630bb685ddc9cdaca1349b2eb5/isort-5.13.2.tar.gz"
    sha256 "48fdfcb9face5d58a4f6dde2e72a1fb8dcaf8ab26f95ab49fab84c2ddefb0109"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/13/fc/128cc9cb8f03208bdbf93d3aa862e16d376844a14f9a0ce5cf4507372de4/platformdirs-4.3.6.tar.gz"
    sha256 "357fb2acbc885b0419afd3ce3ed34564c13c9b95c89360cd9563f73aa5e2b907"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/b1/09/a439bec5888f00a54b8b9f05fa94d7f901d6735ef4e55dcec9bc37b5d8fa/tomlkit-0.13.2.tar.gz"
    sha256 "fff5fe59a87295b278abd31bec92c15d9bc4a06885ab12bcea52c71119392e79"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
