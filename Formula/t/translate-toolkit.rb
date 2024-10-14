class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/55/2c/3badb334f4b98095808c4a35acbe233b31b9c1fed5b1a964f1df022426e9/translate_toolkit-3.14.0.tar.gz"
  sha256 "49418b53bf771daac6cbb0caef47fdde4f2c60a54b01f339f111a3c25b421fd9"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd2813ee04c6eef1c5424874c3175b84ba31d2bf3987544c4453e7ea9c72767e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a057562b25b54f4d56c6190bbcc676c6c3572fed2c450d1a086b580d2f072460"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1001904c1a3a5998ef278e36d1989fe5a09f5e42c4589ceec9f377254bd4862b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9cecccd8d5a99247d841c23468010283d8b9e0db8136eea4f3b0157c0de30635"
    sha256 cellar: :any_skip_relocation, ventura:       "9b049c1c433bb227fca84f40f69fcfb17e88efb2bcba8dae3d3eb90487b16565"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b32502d83e92988c6d9a1b836b9deaa90106e66571d8448c1f99c4a6ab000e64"
  end

  depends_on "python@3.13"

  uses_from_macos "libxml2", since: :ventura
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/6c/63/53559446a878410fc5a5974feb13d31d78d752eb18aeba59c7fef1af7598/wcwidth-0.2.13.tar.gz"
    sha256 "72ea0c06399eb286d978fdedb6923a9eb47e1c486ce63e9b4e64fc18303972b5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    test_file = testpath/"test.po"
    touch test_file
    assert_match "Processing file : #{test_file}", shell_output("#{bin}/pocount --no-color #{test_file}")

    assert_match version.to_s, shell_output("#{bin}/pretranslate --version")
    assert_match version.to_s, shell_output("#{bin}/podebug --version")
  end
end
