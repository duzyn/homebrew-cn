class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/6e/43/ad68cee0365ebff6cccae2cda520f39431cf68336ec42fb1b4600d505a1d/dunamai-1.15.0.tar.gz"
  sha256 "d6088922df3226a8234c228803bb01902a83766d04c2cddb33d4dd3bf85ec9a5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "018a4e9bedbeb897a52d483dc68bb566815e634846dc5afb5d59a1bcc1e8191e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3de569352a308460ad073a21c7a72691dc47f42f4a813a7b4fa71b56f2f4c8e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3d57ac1ea859a32fc998897154e9fcb7322acf43810d0e9483fa2d6dee8f1fc7"
    sha256 cellar: :any_skip_relocation, ventura:        "a0200b0d97cdd5a703cb0b218f0863533446c071b4eb0d1d18d9f670612de4f5"
    sha256 cellar: :any_skip_relocation, monterey:       "4afb6132b06fdd324f9b3f4d1414c3355a7e9fee4a806c8d70600f9cf49eccf0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a3944533cb1b349b62fcce5fe4e79c09aeacd106ac122f3b1094eb00be12023"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec4bb24920e553d5081ef96f374e531ecbd485dd1bc567442be510a5531446f2"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
