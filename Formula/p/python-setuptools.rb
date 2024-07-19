class PythonSetuptools < Formula
  desc "Easily download, build, install, upgrade, and uninstall Python packages"
  homepage "https://setuptools.pypa.io/"
  url "https://files.pythonhosted.org/packages/0e/ae/4a643fdc3b2fe390a6accd55117d5c5af9fbe5da7d2d300c8dd52aa35555/setuptools-71.0.2.tar.gz"
  sha256 "ca359bea0cd5c8ce267d7463239107e87f312f2e2a11b6ca6357565d82b6c0d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a424c3ef3ef068420f461f3146c725980c0da7558ff6bba1d7bc85b9593eb24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5a424c3ef3ef068420f461f3146c725980c0da7558ff6bba1d7bc85b9593eb24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a424c3ef3ef068420f461f3146c725980c0da7558ff6bba1d7bc85b9593eb24"
    sha256 cellar: :any_skip_relocation, sonoma:         "9599af9e777de315550a51c213311d582fcce238cb808adc96254cd5e1fc6486"
    sha256 cellar: :any_skip_relocation, ventura:        "9599af9e777de315550a51c213311d582fcce238cb808adc96254cd5e1fc6486"
    sha256 cellar: :any_skip_relocation, monterey:       "82fdf60a08557f2c21f324c6ad4cd6ef2a3810184e3fa0019eb7868b4348cffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42d236d302454514a99ba7bd2c868f83620fd17b0f89fba523aed21a3c20b475"
  end

  depends_on "python@3.12" => [:build, :test]

  def pythons
    deps.map(&:to_formula)
        .select { |f| f.name.match?(/^python@\d\.\d+$/) }
        .map { |f| f.opt_libexec/"bin/python" }
  end

  def install
    pythons.each do |python|
      system python, "-m", "pip", "install", *std_pip_args, "."
    end
  end

  test do
    pythons.each do |python|
      system python, "-c", "import setuptools"
    end
  end
end
