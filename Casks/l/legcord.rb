cask "legcord" do
  version "1.0.6"
  sha256 "095c6d4ccacecf8602a3a830515d7f7d04e247d0794269f63760ea84df486072"

  url "https://mirror.ghproxy.com/https://github.com/legcord/legcord/releases/download/v#{version}/legcord-#{version}-mac-universal.dmg",
      verified: "github.com/legcord/legcord/"
  name "Legcord"
  desc "Custom Discord client"
  homepage "https://legcord.app/"

  livecheck do
    url "https://legcord.app/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  depends_on macos: ">= :big_sur"

  app "legcord.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/app.legcord.legcord.sfl*",
    "~/Library/Application Support/legcord",
    "~/Library/Preferences/app.legcord.Legcord.plist",
    "~/Library/Saved Application State/app.legcord.Legcord.savedState",
  ]
end
