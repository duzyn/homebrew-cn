cask "grisbi" do
  version "3.0.4"
  sha256 "ff016c36ec113c1cf3733c5363e843834a610a52f42a481c2bc0fd9d589217a1"

  url "https://downloads.sourceforge.net/grisbi/Grisbi-#{version}.dmg?use_mirror=jaist",
      verified: "downloads.sourceforge.net/grisbi/?use_mirror=jaist"
  name "Grisbi"
  desc "Personal financial management program"
  homepage "https://www.grisbi.org/"

  livecheck do
    url "https://sourceforge.net/projects/grisbi/rss?path=/grisbi%20stable"
    regex(%r{url=.*?/Grisbi[^"' >]*?[._-]v?(\d+(?:[.-]\d+)+)\.dmg}i)
  end

  no_autobump! because: :requires_manual_review

  app "Grisbi.app"

  zap trash: [
    "~/Library/Application Support/Grisbi",
    "~/Library/Preferences/org.grisbi.Grisbi.plist",
    "~/Library/Saved Application State/org.grisbi.Grisbi.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
