class PythonArgcomplete < Formula
  desc "Tab completion for Python argparse"
  homepage "https://kislyuk.github.io/argcomplete/"
  url "https://files.pythonhosted.org/packages/fa/b0/e9dfb95bd5afc9b9134a652e33627a6b895faa8e8e725f7ce26518f42850/argcomplete-3.1.5.tar.gz"
  sha256 "86089f25e2fae30f8c6282649fcb52e98fd22b3ffcf952befff9796cb0971e31"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c1b318f9b96d116d09bba569a6ab78698ec433396d9c56ae219e84ec72a80d67"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e94da19a816cd85e1a5ba2edd63399339a8dcfbe0c59ca9a1c4f46f619029122"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8b5f0aca2a86c301f43e538a92472bd441e8565d0eb26cc770955484eb9297e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ae5c19c214e248742edf0c04e56a041f0b0f1186a3eea98488bfc9b5e9830ff"
    sha256 cellar: :any_skip_relocation, ventura:        "45fd789842d7338e01bde78dfd96f8d6367777d3e3ddbd5894cc86276a5b6c2c"
    sha256 cellar: :any_skip_relocation, monterey:       "e8fa541c08b1d62d9d490e9a2a82bcff1abc6b7c5bb23ed1f4cd7f3be4f2510f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc196b970a8c269ccfc52c6731ac0dee69a5f85251af95d0a0d106316686dd16"
  end

  depends_on "python-setuptools" => :build
  depends_on "python@3.10" => [:build, :test]
  depends_on "python@3.11" => [:build, :test]
  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula).sort_by(&:version).filter { |f| f.name.start_with?("python@") }
  end

  def install
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-m", "pip", "install", *std_pip_args, "."
    end

    bash_completion.install "argcomplete/bash_completion.d/_python-argcomplete" => "python-argcomplete"
    zsh_completion.install_symlink bash_completion/"python-argcomplete" => "_python-argcomplete"
  end

  test do
    pythons.each do |python|
      python_exe = python.opt_libexec/"bin/python"
      system python_exe, "-c", "import argcomplete"
    end

    output = shell_output("#{bin}/register-python-argcomplete foo")
    assert_match "_python_argcomplete foo", output
  end
end
