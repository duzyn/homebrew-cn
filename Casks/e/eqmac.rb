cask "eqmac" do
  version "1.8.1"
  sha256 "b88c6557f3b51988ab8c5dbab9a0e95f70f76622c751c9b2aac81cdb9d352133"

  url "https://mirror.ghproxy.com/https://github.com/bitgapp/eqMac/releases/download/v#{version}/eqMac.dmg",
      verified: "github.com/bitgapp/eqMac/"
  name "eqMac"
  desc "System-wide audio equalizer"
  homepage "https://eqmac.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "eqMac.app"

  uninstall delete: "/Library/Audio/Plug-Ins/HAL/eqMac.driver/"

  zap trash: [
    "~/Library/Caches/com.bitgapp.eqmac",
    "~/Library/Preferences/com.bitgapp.eqmac.plist",
    "~/Library/WebKit/com.bitgapp.eqmac",
  ]
end
