cask "eqmac" do
  version "1.8.11"
  sha256 "a9a845e31978dcd24fdd74e64b11bb820ea17fe3454283f1562d478039f87069"

  url "https://mirror.ghproxy.com/https://github.com/bitgapp/eqMac/releases/download/v#{version}/eqMac.dmg",
      verified: "github.com/bitgapp/eqMac/"
  name "eqMac"
  desc "System-wide audio equaliser"
  homepage "https://eqmac.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "eqMac.app"

  uninstall delete: "/Library/Audio/Plug-Ins/HAL/eqMac.driver"

  zap trash: [
    "~/Library/Caches/com.bitgapp.eqmac",
    "~/Library/Preferences/com.bitgapp.eqmac.plist",
    "~/Library/WebKit/com.bitgapp.eqmac",
  ]
end
