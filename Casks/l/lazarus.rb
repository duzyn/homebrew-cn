cask "lazarus" do
  version "3.6"
  sha256 "c32f1fcfb16a969153d660a92e2200f32f5e40ec65d42bbd6af829cd9fe74afb"

  url "https://downloads.sourceforge.net/lazarus/Lazarus%20macOS%20x86-64/Lazarus%20#{version}/Lazarus-#{version}-macosx-x86_64.pkg?use_mirror=jaist",
      verified: "sourceforge.net/lazarus/"
  name "Lazarus"
  desc "IDE for rapid application development"
  homepage "https://www.lazarus-ide.org/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2025-01-26", because: :no_longer_meets_criteria

  depends_on cask: "fpc-laz"
  depends_on cask: "fpc-src-laz"

  pkg "Lazarus-#{version}-macosx-x86_64.pkg"

  uninstall pkgutil: [
              "org.freepascal.pkg.fpcsrc-320-laz",
              "org.lazarus-ide.pkg.LazarusIDE",
            ],
            delete:  "/Applications/Lazarus.app"

  zap trash: "~/.lazarus"

  caveats do
    requires_rosetta
  end
end
