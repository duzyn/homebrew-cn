cask "mullvadvpn" do
  version "2024.8"
  sha256 "ef7373e89bda812c8da747dc905b65bd11e6c129fab69c0c5d6292622d78fea3"

  url "https://mirror.ghproxy.com/https://github.com/mullvad/mullvadvpn-app/releases/download/#{version}/MullvadVPN-#{version}.pkg",
      verified: "github.com/mullvad/mullvadvpn-app/"
  name "Mullvad VPN"
  desc "VPN client"
  homepage "https://mullvad.net/"

  livecheck do
    url "https://mullvad.net/download/app/pkg/latest/"
    strategy :header_match
  end

  conflicts_with cask: "mullvadvpn@beta"
  depends_on macos: ">= :big_sur"

  pkg "MullvadVPN-#{version}.pkg"

  uninstall launchctl: "net.mullvad.daemon",
            pkgutil:   "net.mullvad.vpn",
            delete:    [
              "/Library/Caches/mullvad-vpn",
              "/Library/LaunchDaemons/net.mullvad.daemon.plist",
              "/opt/homebrew/share/fish/vendor_completions.d/mullvad.fish",
              "/usr/local/share/fish/vendor_completions.d/mullvad.fish",
              "/usr/local/share/zsh/site-functions/_mullvad",
              "/var/log/mullvad-vpn",
            ]

  zap trash: [
    "/etc/mullvad-vpn",
    "~/Library/Application Support/Mullvad VPN",
    "~/Library/Logs/Mullvad VPN",
    "~/Library/Preferences/net.mullvad.vpn.plist",
  ]
end
