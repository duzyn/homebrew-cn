cask "lookaway" do
  version "1.5.2"
  sha256 "3fa50995565d4d6926812a01ed8ee94cd9be97b467a3efa2cb67a574f20d3c59"

  url "https://mirror.ghproxy.com/https://github.com/mysticalbits/lookaway-releases/releases/download/#{version}/LookAway.dmg",
      verified: "github.com/mysticalbits/lookaway-releases/"
  name "LookAway"
  desc "Break time reminder app"
  homepage "https://lookaway.app/"

  auto_updates true
  depends_on macos: ">= :monterey"

  app "LookAway.app"

  uninstall quit: "com.mysticalbits.lookaway"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.mysticalbits.lookaway.sfl*",
    "~/Library/Application Support/LookAway",
    "~/Library/Caches/SentryCrash/LookAway",
    "~/Library/Preferences/com.mysticalbits.lookaway.plist",
  ]
end
