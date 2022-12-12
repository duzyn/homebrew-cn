class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility3"
  url "https://files.pythonhosted.org/packages/7a/2a/4bbd676f58d9b4b4846b0c6eecaa2603fcb5b6d4aa35cef2df3df9d757af/volatility3-2.0.1.tar.gz"
  sha256 "e4f3f3a26b2e34e744a2d475b278556b53be769a3c897bfc4bdcbd4feb9089eb"
  license :cannot_represent
  version_scheme 1
  head "https://github.com/volatilityfoundation/volatility3.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "c2fa1be5cbdf6c5adf599d111b8c493c54e6d33fcc9e5b00b3cea067acdcce73"
    sha256 cellar: :any,                 arm64_monterey: "4f26aedeff20798472ec9010d825bc12e0a0e05a30f0c89089f59a4060543561"
    sha256 cellar: :any,                 arm64_big_sur:  "924ce0580c479e68a8f6d6e8862d19a6462610fc89e9accff0d5c5c9d9c0efe5"
    sha256 cellar: :any,                 ventura:        "7a191a437430b21dca1cc226d5b0a6cd74443f97a3f9991adaaef084bd5aa9bb"
    sha256 cellar: :any,                 monterey:       "392653598d6d4bd79c92cb63b44c569091b59754f6af8eeac1d70785d9726c95"
    sha256 cellar: :any,                 big_sur:        "82bcd412f5408ac6cade0a35ca616a6244fdabf4b27c258b96afc52de750fc89"
    sha256 cellar: :any,                 catalina:       "a3dcb3a54ed478a13f36e3c9f4023c09db3d3cedbeeab5f2683d6c6ffc577883"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5d5ba1fd4eac25dfcd1151502bea5ab96a31368466ea9f4ebc1ed512f4a84f55"
  end

  depends_on "python@3.10"
  depends_on "yara"

  # Extra resources are from `requirements.txt`: https://github.com/volatilityfoundation/volatility3#requirements
  resource "attrs" do
    url "https://files.pythonhosted.org/packages/1a/cb/c4ffeb41e7137b23755a45e1bfec9cbb76ecf51874c6f1d113984ecaa32c/attrs-22.1.0.tar.gz"
    sha256 "29adc2665447e5191d0e7c568fde78b21f9672d344281d0c6e1ab085429b22b6"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/0d/25/3496d5e23573bce9c1b753c215b80615e7b557680fcf4f1f804ac7defc97/capstone-5.0.0.tar.gz"
    sha256 "6e18ee140463881c627b7ff7fd655752ddf37d9036295d3dba7b130408fbabaf"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/45/0b/38b06fd9b92dc2b68d58b75f900e97884c45bedd2ff83203d933cf5851c9/future-0.18.2.tar.gz"
    sha256 "b1bead90b70cf6ec3f0710ae53a525360fa360d306a86583adc6bf83a4db537d"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/65/9a/1951e3ed40115622dedc8b28949d636ee1ec69e210a52547a126cd4724e6/jsonschema-4.17.1.tar.gz"
    sha256 "05b2d22c83640cde0b7e0aa329ca7754fbd98ea66ad8ae24aa61328dfe057fa3"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/ee/e1/a7bd302cf5f74547431b4e9b206dbef782d112df6b531f193bb4a29fb1b9/pefile-2021.9.3.tar.gz"
    sha256 "344a49e40a94e10849f0fe34dddc80f773a12b40675bf2f7be4b8be578bdd94a"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/32/09/41ea2633fea5b973dac9829de871b417ff3ce2963d07fd92e3f2d2a9ee9b/pycryptodome-3.14.1.tar.gz"
    sha256 "e04e40a7f8c1669195536a37979dd87da2c32dbdc73d6fe35f0077b0c17c803b"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/c9/d9/f0e15174adae818a8dd9bb5989a8343abc3a1df29757c5b1f00aecdd1276/yara-python-4.2.0.tar.gz"
    sha256 "d02f239f429c6c94e60b500246d376595fbed8d9124209d332b6f8e7cfb5ec6e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vol", "--help"
  end
end
