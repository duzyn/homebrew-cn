cask "stash" do
  version "2.6.6,308"
  sha256 "144933dbd5b6ebfddbb53e5ef1c2622998ebe0669f0ae1f08617ecd76cf341cf"

  url "https://mac-release-static.stash.ws/Stash-build-#{version.csv.second}.zip"
  name "Stash"
  desc "Network tool based on Clash"
  homepage "https://stash.ws/"

  livecheck do
    url "https://mac-release.stash.ws/appcast.xml"
    strategy :sparkle
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Stash.app"

  uninstall quit:   "ws.stash.app.mac",
            delete: [
              "/Library/LaunchDaemons/ws.stash.app.mac.daemon.helper.plist",
              "/Library/PrivilegedHelperTools/ws.stash.app.mac.daemon.helper",
            ]

  zap trash: [
    "~/Library/Application Scripts/group.ws.stash.app",
    "~/Library/Application Scripts/ws.stash.app",
    "~/Library/Application Scripts/ws.stash.app.mac-LaunchAtLoginHelper",
    "~/Library/Application Support/Stash",
    "~/Library/Application Support/ws.stash.app.mac",
    "~/Library/Caches/ws.stash.app.mac",
    "~/Library/Caches/ws.stash.app.mac.dashboard",
    "~/Library/Containers/ws.stash.app.mac-LaunchAtLoginHelper",
    "~/Library/Group Containers/group.ws.stash.app",
    "~/Library/HTTPStorages/ws.stash.app.mac",
    "~/Library/HTTPStorages/ws.stash.app.mac.binarycookies",
    "~/Library/Preferences/ws.stash.app.mac.plist",
  ]
end
