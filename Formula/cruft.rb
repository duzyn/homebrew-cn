class Cruft < Formula
  include Language::Python::Virtualenv

  desc "Utility that creates projects from templates and maintains the cruft afterwards"
  homepage "https://cruft.github.io/cruft/"
  url "https://files.pythonhosted.org/packages/1d/a2/e3bfcc5780b9e3cde61940155cd31a4dd9a7432851561239475ada60eaef/cruft-2.12.0.tar.gz"
  sha256 "57455d33a60684c945d501dcea2b1c57dc0fb200a0090f07c83da1603382cbb1"
  license "MIT"
  head "https://github.com/cruft/cruft.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce4bf956454442e38309c6b5b97d1d48bbc6b6a8efc3d13e767a6b696059a79c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9010104e690059b59131663fdf56f33769809a477cb9a1a506a1799c06e4c89b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a19296a6e5d200386616360e068198a13f90494bec356a5723afe31a9112964d"
    sha256 cellar: :any_skip_relocation, ventura:        "96bf2cd7c3ecf8aa31009ce56dd81aeedc76fae68bd67f976078c8b183e00ae5"
    sha256 cellar: :any_skip_relocation, monterey:       "d734ed8c44ea81c655828c3e3bed2362b1ee54ed26fd450ca22f77aa904881d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "0fdbde025ce2e867437f6540197f4a8cbe854dfcfdbb252183a9021d2c414906"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63b05d7803e18d103dd06ebe74d64ddef52cdaff3be39f50b812771c3afc9f9f"
  end

  depends_on "cookiecutter"
  depends_on "python@3.11"
  depends_on "six"

  resource "gitdb" do
    url "https://files.pythonhosted.org/packages/4b/47/dc98f3d5d48aa815770e31490893b92c5f1cd6c6cf28dd3a8ae0efffac14/gitdb-4.0.10.tar.gz"
    sha256 "6eb990b69df4e15bad899ea868dc46572c3f75339735663b81de79b06f17eb9a"
  end

  resource "GitPython" do
    url "https://files.pythonhosted.org/packages/22/ab/3dd8b8a24399cee9c903d5f7600d20e8703d48904020f46f7fa5ac5474e9/GitPython-3.1.29.tar.gz"
    sha256 "cc36bfc4a3f913e66805a28e84703e419d9c264c1077e537b54f0e1af85dbefd"
  end

  resource "smmap" do
    url "https://files.pythonhosted.org/packages/21/2d/39c6c57032f786f1965022563eec60623bb3e1409ade6ad834ff703724f3/smmap-5.0.0.tar.gz"
    sha256 "c840e62059cd3be204b0c9c9f74be2c09d5648eddd4580d9314c3ecde0b30936"
  end

  resource "typer" do
    url "https://files.pythonhosted.org/packages/e1/45/bcbc581f87c8d8f2a56b513eb994d07ea4546322818d95dc6a3caf2c928b/typer-0.7.0.tar.gz"
    sha256 "ff797846578a9f2a201b53442aedeb543319466870fbe1c701eab66dd7681165"
  end

  def install
    virtualenv_install_with_resources

    # we depend on cookiecutter, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    cookiecutter = Formula["cookiecutter"].opt_libexec
    (libexec/site_packages/"homebrew-cookiecutter.pth").write cookiecutter/site_packages
  end

  test do
    system bin/"cruft", "create", "--no-input", "https://github.com/audreyr/cookiecutter-pypackage.git"
    assert (testpath/"python_boilerplate").directory?
    assert_predicate testpath/"python_boilerplate/.cruft.json", :exist?
  end
end
