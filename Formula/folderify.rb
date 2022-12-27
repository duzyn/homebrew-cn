class Folderify < Formula
  include Language::Python::Virtualenv

  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://files.pythonhosted.org/packages/68/03/a4834a40d95a0bc2debdbad7e0e1bf909a95ff68c0a64098ea52f6ccb794/folderify-2.3.1.tar.gz"
  sha256 "0927c9453dc8efb6ea4addb0eee2711528152045f22d411c9de1e7f45621f06c"
  license "MIT"
  revision 1
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f80bae8eede3de718f6827c8f079ba573ecc77849d29c080a5cdff10bed4f7c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37aedb692e39efba0f2da125fef6c5fa91d214d57a159067831d31fd03a73324"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e9df72f0aa9b70c864d2bf24dae188f3be89b80b304798d9aa08bb92505a6652"
    sha256 cellar: :any_skip_relocation, ventura:        "2ac11aa91e532e4118ef7860dd5cecfe903ced3d8b0c549374a4410424bb732f"
    sha256 cellar: :any_skip_relocation, monterey:       "2ac11aa91e532e4118ef7860dd5cecfe903ced3d8b0c549374a4410424bb732f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c0d30d913babe9c33ce461319a123c4cf6db2ca67329347440fec56c5c7102b"
  end

  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos
  depends_on "python@3.11"

  resource "osxiconutils" do
    url "https://github.com/sveinbjornt/osxiconutils.git",
        revision: "d3b43f1dd5e1e8ff60d2dbb4df4e872388d2cd10"
  end

  def python3
    "python3.11"
  end

  def install
    venv = virtualenv_create(libexec, python3, system_site_packages: false)
    venv.pip_install_and_link buildpath

    # Replace bundled pre-built `seticon` with one we built ourselves.
    resource("osxiconutils").stage do
      xcodebuild "-arch", Hardware::CPU.arch,
                 "-parallelizeTargets",
                 "-project", "osxiconutils.xcodeproj",
                 "-target", "seticon",
                 "-configuration", "Release",
                 "CONFIGURATION_BUILD_DIR=build",
                 "SYMROOT=."

      (libexec/Language::Python.site_packages(python3)/"folderify/lib").install "build/seticon"
    end
  end

  test do
    # Copies an example icon
    site_packages = libexec/Language::Python.site_packages(python3)
    cp(
      "#{site_packages}/folderify/GenericFolderIcon.Yosemite.iconset/icon_16x16.png",
      "icon.png",
    )
    # folderify applies the test icon to a folder
    system "folderify", "icon.png", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
