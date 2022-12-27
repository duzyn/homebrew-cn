class PythonBuild < Formula
  include Language::Python::Virtualenv

  desc "Simple, correct PEP 517 build frontend"
  homepage "https://github.com/pypa/build"
  url "https://files.pythonhosted.org/packages/0f/61/aaf43fbb36cc4308be8ac8088f52db9622b0dbf1f0880c1016ae6aa03f46/build-0.9.0.tar.gz"
  sha256 "1a07724e891cbd898923145eb7752ee7653674c511378eb9c7691aab1612bc3c"
  license "MIT"
  head "https://github.com/pypa/build.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "627b7ce96d4cc4bb54072f1348a1159ce7bd93bd1909d72e0797e23822360729"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f4bad095b425f11e26daa8450d716d6d3d87a6b086fa93e746e42b2b5edca4e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f734c014c744750da9b3ff86252ccc04830b22219dadcc7705edb6e2426357cc"
    sha256 cellar: :any_skip_relocation, ventura:        "3eef3b41a48887701c20d382613226d4b6066bf3e1149c0fe1adf1ab013b1542"
    sha256 cellar: :any_skip_relocation, monterey:       "f687f81100265c55552369fa8da87af664b6a126570b7eb0cacc0f5d82f14eae"
    sha256 cellar: :any_skip_relocation, big_sur:        "63acd4ceb75a08030b0be6868d99e5fb27f10397601161b107ef0be218a28601"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "547a0ff2639a4eddba12c058af02c73b1df8a63c46f316005c756a76fbb8a82d"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/4d/19/e11fcc88288f68ae48e3aa9cf5a6fd092a88e629cb723465666c44d487a0/pep517-0.13.0.tar.gz"
    sha256 "ae69927c5c172be1add9203726d4b84cf3ebad1edcd5f71fcdc746e66e829f59"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    stable.stage do
      system "pyproject-build"
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}.tar.gz", :exist?
      assert_predicate Pathname.pwd/"dist/build-#{stable.version}-py3-none-any.whl", :exist?
    end
  end
end
