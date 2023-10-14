class PipTools < Formula
  include Language::Python::Virtualenv

  desc "Locking and sync for Pip requirements files"
  homepage "https://pip-tools.readthedocs.io"
  url "https://files.pythonhosted.org/packages/fd/01/f0055058a86a888f32ac794fa68d5a25c2d2f7a3e8181474b711faaa2145/pip-tools-7.3.0.tar.gz"
  sha256 "8e9c99127fe024c025b46a0b2d15c7bd47f18f33226cf7330d35493663fc1d1d"
  license "BSD-3-Clause"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1a7b579e46fca595a5cf52c903775a472b2927678d3338b18a0853b4b21adb8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "083814a643648844cff343169c241a6f1400596172a42110b00400e067cf5116"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e443adccaaefb8998d9c6b00839e0095ab874f30826c15968432e4b6e1226cae"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0700411bc42b66d3968dba5b05315ad9e7e1e8107601fac251ec96b4cf24644"
    sha256 cellar: :any_skip_relocation, ventura:        "a90ad47e2106a055d5b0f6472d818802f4c204f9c15a7cb630d51270317ed88e"
    sha256 cellar: :any_skip_relocation, monterey:       "fc0ec435d03fd01659fdb13635b458bfd193b59b24ebdb8c0f60d04a1818ecb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2dd03cd2635055582c010dbedb4cc56f022990283fc9333183a5d396596f55"
  end

  depends_on "python-build"
  depends_on "python-packaging"
  depends_on "python-pyproject-hooks"
  depends_on "python@3.11"

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/c9/3d/02a14af2b413d7abf856083f327744d286f4468365cddace393a43d9d540/wheel-0.41.1.tar.gz"
    sha256 "12b911f083e876e10c595779709f8a88a59f45aacc646492a67fe9ef796c1b47"
  end

  def install
    virtualenv_install_with_resources

    %w[pip-compile pip-sync].each do |script|
      generate_completions_from_executable(bin/script, shells: [:fish, :zsh], shell_parameter_format: :click)
    end
  end

  test do
    (testpath/"requirements.in").write <<~EOS
      pip-tools
      typing-extensions
    EOS

    compiled = shell_output("#{bin}/pip-compile requirements.in -q -o -")
    assert_match "This file is autogenerated by pip-compile", compiled
    assert_match "# via pip-tools", compiled
  end
end