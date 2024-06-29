class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/df/f3/e552877a02574b7919855a8d1f372591e67d276ea880c079968e7b3ba353/pylint-3.2.5.tar.gz"
  sha256 "e9b7171e242dcc6ebd0aaa7540481d1a72860748a0a7816b8fe6cf6c80a6fe7e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1d9d29eb1948e4147f3fee637973e6f6f55a0e6bbdb5da8aff0692fb97cf6fe"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1d9d29eb1948e4147f3fee637973e6f6f55a0e6bbdb5da8aff0692fb97cf6fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c1d9d29eb1948e4147f3fee637973e6f6f55a0e6bbdb5da8aff0692fb97cf6fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "4321c0221cc982c5fd1118cc5c2ab9ac8d6c5f3cf6b3897b554d257c02dca9c7"
    sha256 cellar: :any_skip_relocation, ventura:        "4321c0221cc982c5fd1118cc5c2ab9ac8d6c5f3cf6b3897b554d257c02dca9c7"
    sha256 cellar: :any_skip_relocation, monterey:       "4321c0221cc982c5fd1118cc5c2ab9ac8d6c5f3cf6b3897b554d257c02dca9c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce129e435cf1409bb8b28b1337efe3081a12884300c3c4700ab1b137cd688b29"
  end

  depends_on "python@3.12"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/27/8f/79adb88627d194824decf7b9f4dde9e059b251a7b76809c99f4803be258e/astroid-3.2.2.tar.gz"
    sha256 "8ead48e31b92b2e217b6c9733a21afafe479d52d6e164dd25fb1a770c7c3cf94"
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
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/2b/ab/18f4c8f2bec75eb1a7aebcc52cdb02ab04fd39ff7025bb1b1c7846cc45b8/tomlkit-0.12.5.tar.gz"
    sha256 "eef34fba39834d4d6b73c9ba7f3e4d1c417a4e56f89a7e96e090dd0d24b8fb3c"
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
