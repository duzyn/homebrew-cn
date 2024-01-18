cask "battery" do
  version "1.2.1"
  sha256 "701884af16451ef956c9acb41e9bcb6d6eae07e6ca07840c67e56e0897b042d1"

  url "https://mirror.ghproxy.com/https://github.com/actuallymentor/battery/releases/download/v#{version}/battery-#{version}-mac-arm64.dmg"
  name "Battery"
  desc "CLI for managing the battery charging status"
  homepage "https://github.com/actuallymentor/battery/"

  auto_updates true
  depends_on macos: ">= :high_sierra"
  depends_on arch: :arm64

  app "battery.app"

  uninstall delete: "/usr/local/bin/smc"

  zap trash: [
    "~/.battery",
    "~/Library/Application Support/battery",
    "~/Library/LaunchAgents/battery.plist",
    "~/Library/Preferences/co.palokaj.battery.plist",
    "~/Library/Preferences/org.mentor.Battery.plist",
    "~/Library/Saved Application State/co.palokaj.battery.savedState",
  ]
end
