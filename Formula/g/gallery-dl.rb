class GalleryDl < Formula
  include Language::Python::Virtualenv

  desc "Command-line downloader for image-hosting site galleries and collections"
  homepage "https://github.com/mikf/gallery-dl"
  url "https://files.pythonhosted.org/packages/10/fc/1c19d4a906a980464e8f4041e967740bd0849dae83fe715d9c58d3e31b71/gallery_dl-1.27.2.tar.gz"
  sha256 "09373a081005231397e4177f872ddeeb931b5b2236c059fe6ba863e24b6e063a"
  license "GPL-2.0-only"
  head "https://github.com/mikf/gallery-dl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ad0eeec77b1df8f08b1335da9f325ff1fdcf1db16e9d3326cd233929ff51ef25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ad0eeec77b1df8f08b1335da9f325ff1fdcf1db16e9d3326cd233929ff51ef25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad0eeec77b1df8f08b1335da9f325ff1fdcf1db16e9d3326cd233929ff51ef25"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad0eeec77b1df8f08b1335da9f325ff1fdcf1db16e9d3326cd233929ff51ef25"
    sha256 cellar: :any_skip_relocation, ventura:        "ad0eeec77b1df8f08b1335da9f325ff1fdcf1db16e9d3326cd233929ff51ef25"
    sha256 cellar: :any_skip_relocation, monterey:       "ad0eeec77b1df8f08b1335da9f325ff1fdcf1db16e9d3326cd233929ff51ef25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6eb7b1331517e7e5d35a0197bc5f137da3f3b4700df3b03a937920624ab0eea1"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/63/09/c1bc53dab74b1816a00d8d030de5bf98f724c52c1635e07681d312f20be8/charset-normalizer-3.3.2.tar.gz"
    sha256 "f30c3cb33b24454a82faecaf01b19c18562b1e89558fb6c56de4d9118a032fd5"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/21/ed/f86a79a07470cb07819390452f178b3bef1d375f2ec021ecfc709fc7cf07/idna-3.7.tar.gz"
    sha256 "028ff3aadf0609c1fd278d8ea3089299412a7a8b9bd005dd08b9f8285bcb5cfc"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/63/70/2bf7780ad2d390a8d301ad0b550f1581eadbd9a20f896afe06353c2a2913/requests-2.32.3.tar.gz"
    sha256 "55365417734eb18255590a9ff9eb97e9e1da868d4ccd6402399eaf68af20a760"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/43/6d/fa469ae21497ddc8bc93e5877702dca7cb8f911e337aca7452b5724f1bb6/urllib3-2.2.2.tar.gz"
    sha256 "dd505485549a7a552833da5e6063639d0d177c04f23bc3864e41e5dc5f612168"
  end

  def install
    system "make", "man", "completion" if build.head?
    virtualenv_install_with_resources
    man1.install_symlink libexec/"share/man/man1/gallery-dl.1"
    man5.install_symlink libexec/"share/man/man5/gallery-dl.conf.5"
    bash_completion.install libexec/"share/bash-completion/completions/gallery-dl"
    zsh_completion.install libexec/"share/zsh/site-functions/_gallery-dl"
    fish_completion.install libexec/"share/fish/vendor_completions.d/gallery-dl.fish"
  end

  test do
    system bin/"gallery-dl", "https://imgur.com/a/dyvohpF"
    expected_sum = "126fa3d13c112c9c49d563b00836149bed94117edb54101a1a4d9c60ad0244be"
    file_sum = Digest::SHA256.hexdigest File.read(testpath/"gallery-dl/imgur/dyvohpF/imgur_dyvohpF_001_ZTZ6Xy1.png")
    assert_equal expected_sum, file_sum
  end
end
