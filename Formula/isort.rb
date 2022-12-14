class Isort < Formula
  include Language::Python::Virtualenv

  desc "Sort Python imports automatically"
  homepage "https://pycqa.github.io/isort/"
  url "https://files.pythonhosted.org/packages/42/48/d46b8a013e2f9c6f639197b1d96791196133d8a36a5b594529cfdb780a8d/isort-5.11.2.tar.gz"
  sha256 "dd8bbc5c0990f2a095d754e50360915f73b4c26fc82733eb5bfc6b48396af4d2"
  license "MIT"
  head "https://github.com/PyCQA/isort.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{href=.*?/packages.*?/isort[._-]v?(\d+(?:\.\d+)*(?:[a-z]\d+)?)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2e15ada47fe4e01ba58692ae4de2da7dd80cc3989eced93be44ed6a0ad3b18c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8196480e2be5b359b7f7b0764683d9b420a4927c38e9fe8c7e36872fa66da67"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "056f649794d994a696b352f80d5998902801830cd0c1e29ca5a73f2f2c266774"
    sha256 cellar: :any_skip_relocation, ventura:        "e0ce7da2c5c9d56de18ab6665a2cd563afc4e4f1243b82c0fab367cf64d4c4ba"
    sha256 cellar: :any_skip_relocation, monterey:       "66c9e90b7fa42e6b36bee1c76e3594c26ddb58b733a393f47b1b880b6eb020b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "034d0d70e22cbe0e52738cfaf724f0767f63a502482b24d05de3e90e6660ef8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc49377733fdf41010e4e163b93e73988504b09141e80a5170fcdaf89bc74f70"
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
