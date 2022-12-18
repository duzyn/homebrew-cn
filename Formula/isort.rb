class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/e2/43/d99899bfa24a3914f0318536918ab8c91c09350b5482e4e9bb7291840ae3/isort-5.11.3.tar.gz"
  sha256 "a8ca25fbfad0f7d5d8447a4314837298d9f6b23aed8618584c894574f626b64b"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d3e30bd31e20ed1b5ac173ae54963be60928ef2bb95c366e6525405f1f0baa3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74a6a29ccb608d418cecceb90dedf44e669bd91db2291561d7cc24c09f28218d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53eb91e92027323fa41db5969f1f831a122fea9bf427e8c9dbfa40d8aaa2a49a"
    sha256 cellar: :any_skip_relocation, ventura:        "a997cf0971e42165e833ef702f75f8218dffdb85bd7516434bc6352339a2305e"
    sha256 cellar: :any_skip_relocation, monterey:       "b9439fe49efbc61f6e7b6378d2df45fb45bfc8046d9b0da456479cb8e3f7470b"
    sha256 cellar: :any_skip_relocation, big_sur:        "00b26b17046f3036885c72cc6a436f084c18abd70067aa1700a8fef5ca0158f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dae4d0b47399258b753b15a5e38947b60609afcdef6d0162db8eec106a890e6c"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"isort_test.py").write <<~EOS
      from third_party import lib
      import os
    EOS
    system bin/"isort", "isort_test.py"
    assert_equal "import os\n\nfrom third_party import lib\n", (testpath/"isort_test.py").read
  end
end
