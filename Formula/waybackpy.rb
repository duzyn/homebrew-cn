class Waybackpy < Formula
  include Language::Python::Virtualenv

  desc "Wayback Machine API interface & command-line tool"
  homepage "https://pypi.org/project/waybackpy/"
  url "https://files.pythonhosted.org/packages/34/ab/90085feb81e7fad7d00c736f98e74ec315159ebef2180a77c85a06b2f0aa/waybackpy-3.0.6.tar.gz"
  sha256 "497a371756aba7644eb7ada0ebd4edb15cb8c53bc134cc973bf023a12caff83f"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "203d0696cda06d03a3f0b909a10a4241308e807aa172b9cb116959957e30189f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a99fd25b6c9efbcfcf9713d5df5f837d504cf75c5821b70a393899b93565d5c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7e37f1a14753480fa41e0565de432f3d1fc6cc4a9dc3b6f310bd96b9c0d90c5"
    sha256 cellar: :any_skip_relocation, ventura:        "8c90b9b262f58114a07ef869f0e3c24782abdda330f08da78c04ef4824ec5a7c"
    sha256 cellar: :any_skip_relocation, monterey:       "c0af8229a0cc143daab0d884b4ca7e486fe00caad22264705ddd94594b09cae0"
    sha256 cellar: :any_skip_relocation, big_sur:        "786d6e6760ca75a613d324b36b22d7ed8e9ff1581b61f7ff4d74feaf0e772064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a49fd06be723daa5d3216efe791fc6be5606f7ba3abd85feaa55550431d6f131"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/cb/a4/7de7cd59e429bd0ee6521ba58a75adaec136d32f91a761b28a11d8088d44/certifi-2022.9.24.tar.gz"
    sha256 "0d9c601124e5a6ba9712dbc60d9c53c21e34f5f641fe83002317394311bdce14"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/a1/34/44964211e5410b051e4b8d2869c470ae8a68ae274953b1c7de6d98bbcf94/charset-normalizer-2.1.1.tar.gz"
    sha256 "5a3d016c7c547f69d6f81fb0db9449ce888b418b5b9952cc5e6e66843e9dd845"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/a5/61/a867851fd5ab77277495a8709ddda0861b28163c4613b011bc00228cc724/requests-2.28.1.tar.gz"
    sha256 "7c5599b102feddaa661c826c56ab4fee28bfd17f5abca1ebbe3e7f19d7c97983"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/waybackpy"
  end

  test do
    output = shell_output("#{bin}/waybackpy -o --url https://brew.sh")
    assert_match "20130328163936", output
  end
end
