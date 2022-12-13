class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/a2/97/77b83392bc0a454a9454ba2211cd5380856323df55b870f14a645bb6882a/translate-toolkit-3.8.0.tar.gz"
  sha256 "330e79b272ebbfce7115b38e6f7cbb57352be6ae9bddc6306ff2ee6e1a569905"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f017a6c32081c5827b60c84a7e4a96f63abeccc01bacaf09b6f45cdcc93eece6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "744d75fdc2ad123728e9c5d108c7b6003b190c20411df746990e34b03b38eb35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a0bffe3c9fe3c54d53779c6f000264880c713ee23668aa50233d5cdb0e31ffa"
    sha256 cellar: :any_skip_relocation, ventura:        "8eab96dc9fce3aafab1d69af137f031a37ebae9e0dc9f7ae7afa590996cd9272"
    sha256 cellar: :any_skip_relocation, monterey:       "b14944279707b355105454d7ffbe5ddf4d502f245237d576bf799778c9f48f6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef98143cc490b50bd05b22fbff34f15949982ecc131c52838db3f0258cd4d65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9003a50b699149bb99c46e81292f4f1b49d7a6380d723ee78123aca41b5596"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/70/bb/7a2c7b4f8f434aa1ee801704bf08f1e53d7b5feba3d5313ab17003477808/lxml-4.9.1.tar.gz"
    sha256 "fe749b052bb7233fe5d072fcb549221a8cb1a16725c47c37e42b0b9cb3ff2c3f"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
