cask "sol" do
  version "2.1.28"
  sha256 "bf1065a945e5d58184726a2fc1534f8f099157b85f4710417e86259e60eb9599"

  url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/ospfranco/sol/main/releases/#{version}.zip",
      verified: "mirror.ghproxy.com/https://raw.githubusercontent.com/ospfranco/sol/"
  name "Sol"
  desc "Launcher & command palette"
  homepage "https://github.com/ospfranco/sol"

  livecheck do
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/ospfranco/sol/main/releases/appcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :big_sur"

  app "Sol.app"

  uninstall launchctl: "com.ospfranco.sol-LaunchAtLoginHelper",
            quit:      "com.ospfranco.sol"

  zap trash: [
    "~/Library/Application Scripts/com.ospfranco.sol-LaunchAtLoginHelper",
    "~/Library/Application Support/com.ospfranco.sol",
    "~/Library/Containers/com.ospfranco.sol-LaunchAtLoginHelper",
    "~/Library/HTTPStorages/com.ospfranco.sol",
    "~/Library/Preferences/com.ospfranco.sol.plist",
  ]
end
