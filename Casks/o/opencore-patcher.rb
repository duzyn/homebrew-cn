cask "opencore-patcher" do
  version "1.4.2"
  sha256 "bb377c3c1f1341be295288f085097df3e509e2cff70266b7c1a776023796ed65"

  url "https://mirror.ghproxy.com/https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/#{version}/OpenCore-Patcher-GUI.app.zip",
      verified: "github.com/dortania/OpenCore-Legacy-Patcher/"
  name "OpenCore Legacy Patcher GUI"
  desc "Boot loader to inject/patch current features for unsupported Macs"
  homepage "https://dortania.github.io/OpenCore-Legacy-Patcher/"

  app "OpenCore-Patcher.app"

  uninstall delete: "/Library/LaunchAgents/com.dortania.opencore-legacy-patcher.auto-patch.plist"

  zap trash: [
    "/Users/Shared/.com.dortania.opencore-legacy-patcher.plist",
    "~/Library/Application Support/CrashReporter/OpenCore-Patcher*",
    "~/Library/Preferences/com.dortania.opencore-legacy-patcher-wxpython.plist",
    "~/Library/Saved Application State/com.dortania.opencore-legacy-patcher-wxpython.savedState",
    "~/Library/Saved Application State/com.dortania.opencore-legacy-patcher.savedState",
  ]
end
