class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility3"
  url "https://files.pythonhosted.org/packages/5f/81/72ad1b892e6c71d6f868af90f2df9505c29c393eb822c175f30f4ed5a18c/volatility3-2.4.0.tar.gz"
  sha256 "61cd695d0aa826e9b655c1abe88b46356088e367b0eadf33cc08075c1203f244"
  license :cannot_represent
  version_scheme 1
  head "https://github.com/volatilityfoundation/volatility3.git", branch: "develop"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "5eb86910bd938108a7988fd95b5fa6262e8e68a926d1b7eb68b52f170c37391a"
    sha256 cellar: :any,                 arm64_monterey: "4acdf5b6ae70abb80ade5fd647ef84166f4f59514b1fa7c683959df15e4acd0d"
    sha256 cellar: :any,                 arm64_big_sur:  "4f56832a907494eba0248c858a34a018a60811f1d930f7259e3d3bc5ac433462"
    sha256 cellar: :any,                 ventura:        "12c2c803293597ded40374ebdec0318cbc60aeb3492360440e5a9236a6a04630"
    sha256 cellar: :any,                 monterey:       "26ca70a1baaff8f4106b4781b434e828b8547dff66de6aab9f9599417f33f7ff"
    sha256 cellar: :any,                 big_sur:        "ea5cf2c5fa52e0d9052ab87d191b0f3d0ae1816dcec97aea2a7357b95772fead"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7a70d3704a4d21200cfd5e47c69741c8d47a3c27e4595bcc0d73223a132dfe6"
  end

  depends_on "python@3.11"
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
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/48/30/4559d06bad5bb627733dac1ef28c34f5e35f1461247ba63e5f6366901277/pefile-2022.5.30.tar.gz"
    sha256 "a5488a3dd1fd021ce33f969780b88fe0f7eebb76eb20996d7318f307612a045b"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/0d/66/5e4a14e91ffeac819e6888037771286bc1b86869f25d74d60bc4a61d2c1e/pycryptodome-3.16.0.tar.gz"
    sha256 "0e45d2d852a66ecfb904f090c3f87dc0dfb89a499570abad8590f10d9cffb350"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/b8/ef/325da441a385a8a931b3eeb70db23cb52da42799691988d8d943c5237f10/pyrsistent-0.19.2.tar.gz"
    sha256 "bfa0351be89c9fcbcb8c9879b826f4353be10f58f8a677efab0c017bf7137ec2"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/a4/2b/d36b6399027bb888faed23e3393f4efc3568996a5c386233b364d9e701d5/yara-python-4.2.3.tar.gz"
    sha256 "31f6f6f2fdca4c5ddfeed7cc6d29afad6af7dc259dde284df2d7ea5ae15ee69a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vol", "--help"
  end
end
