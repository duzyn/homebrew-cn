cask "aegisub" do
  version "3.4.1"
  sha256 "006f69f117552a071503f723ad9ac8685e8c051055dcb132e6409c9a2f4cde64"

  url "https://mirror.ghproxy.com/https://github.com/TypesettingTools/Aegisub/releases/download/v#{version}/Aegisub-#{version}.dmg",
      verified: "github.com/TypesettingTools/Aegisub/"
  name "Aegisub"
  desc "Create and modify subtitles"
  homepage "https://aegisub.org/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Aegisub.app"

  uninstall quit: "com.aegisub.aegisub"

  zap trash: [
    "~/Library/Application Support/Aegisub",
    "~/Library/Preferences/com.aegisub.aegisub.plist",
    "~/Library/Saved Application State/com.aegisub.aegisub.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
