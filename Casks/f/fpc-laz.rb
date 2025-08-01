cask "fpc-laz" do
  version "3.2.2,4.2"
  sha256 "05d4510c8c887e3c68de20272abf62171aa5b2ef1eba6bce25e4c0bc41ba8b7d"

  url "https://downloads.sourceforge.net/lazarus/Lazarus%20macOS%20x86-64/Lazarus%20#{version.csv.second}/fpc-#{version.csv.first}.intelarm64-macosx.dmg?use_mirror=jaist",
      verified: "sourceforge.net/lazarus/"
  name "Pascal compiler for Lazarus"
  desc "Pascal compiler for Lazarus"
  homepage "https://www.lazarus-ide.org/"

  livecheck do
    url "https://sourceforge.net/projects/lazarus/rss?path=/Lazarus%20macOS%20x86-64"
    regex(%r{url=.*?/Lazarus(?:%20|[._-])v?(\d+(?:\.\d+)+)/fpc[._-]v?(\d+(?:\.\d+)+)[^"' >]+?\.(?:dmg|pkg)}i)
    strategy :sourceforge do |page, regex|
      page.scan(regex).map { |match| "#{match[1]},#{match[0]}" }
    end
  end

  no_autobump! because: :requires_manual_review

  disable! date: "2026-09-01", because: :unsigned

  conflicts_with formula: "fpc"

  pkg "fpc-#{version.csv.first}-intelarm64-macosx.mpkg/Contents/Packages/fpc-#{version.csv.first}-intelarm64-macosx.pkg"

  uninstall pkgutil: [
    "org.freepascal.fpc",
    "org.freepascal.freePascalCompiler320.fpcinst386",
    "org.freepascal.freePascalCompiler322.fpcinstintelarm64",
  ]

  # No zap stanza required

  caveats do
    files_in_usr_local
  end
end
