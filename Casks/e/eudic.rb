cask "eudic" do
  version "4.5.4,1120"
  sha256 "1f528f11a37f1f352b77f20286815e62a2f4a7ab2deebbd49e77aa3fed801dee"

  url "https://static.frdic.com/pkg/eudicmac.dmg?v=#{version.csv.second}",
      verified:   "static.frdic.com/",
      user_agent: :fake
  name "Eudic"
  name "欧路词典"
  desc "European dictionary"
  homepage "https://www.eudic.net/v4/en/app/eudic"

  livecheck do
    url "https://www.eudic.net/update/eudic_mac.xml"
    strategy :sparkle
  end

  depends_on macos: ">= :high_sierra"

  app "Eudic.app"

  uninstall quit: [
    "com.eusoft.eudic",
    "com.eusoft.eudic.LightPeek",
  ]

  zap trash: [
    "~/Library/Application Scripts/com.eusoft.eudic.QuickLook",
    "~/Library/Application Support/com.eusoft.eudic",
    "~/Library/Caches/com.eusoft.eudic",
    "~/Library/Caches/com.eusoft.eudic.LightPeek",
    "~/Library/Containers/com.eusoft.eudic.QuickLook",
    "~/Library/Eudb_en",
    "~/Library/HTTPStorages/com.eusoft.eudic",
    "~/Library/HTTPStorages/com.eusoft.eudic.binarycookies",
    "~/Library/Preferences/com.eusoft.eudic.plist",
    "~/Library/Preferences/com.eusoft.eudic.LightPeek.plist",
    "~/Library/Preferences/group.com.eusoft.eudic.plist",
    "~/Library/WebKit/com.eusoft.eudic",
    "~/Library/WebKit/com.eusoft.eudic.LightPeek",
  ]
end
