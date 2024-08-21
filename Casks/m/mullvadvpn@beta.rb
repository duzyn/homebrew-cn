cask "mullvadvpn@beta" do
  version "2024.5-beta1"
  sha256 "fd6f576420a298badad9c9b62516484a825480d7966b6fe95702a788c33ff894"

  url "https://mirror.ghproxy.com/https://github.com/mullvad/mullvadvpn-app/releases/download/#{version}/MullvadVPN-#{version}.pkg",
      verified: "github.com/mullvad/mullvadvpn-app/"
  name "Mullvad VPN"
  desc "VPN client"
  homepage "https://mullvad.net/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+[._-]beta\d*)$/i)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"]

        match = release["tag_name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  conflicts_with cask: "mullvadvpn"

  pkg "MullvadVPN-#{version}.pkg"

  uninstall launchctl: "net.mullvad.daemon",
            quit:      "net.mullvad.vpn",
            pkgutil:   "net.mullvad.vpn"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/net.mullvad.vpn.sfl*",
    "~/Library/Application Support/Mullvad VPN",
    "~/Library/Logs/Mullvad VPN",
    "~/Library/Preferences/net.mullvad.vpn.helper.plist",
    "~/Library/Preferences/net.mullvad.vpn.plist",
  ]
end
