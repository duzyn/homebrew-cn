cask "opencore-patcher" do
  version "2.0.2"
  sha256 "405d716996469e143ec6ecd89e04cbb75dcd5bf6c0e437df9cc435c7f22d6b1c"

  url "https://mirror.ghproxy.com/https://github.com/dortania/OpenCore-Legacy-Patcher/releases/download/#{version}/OpenCore-Patcher.pkg",
      verified: "github.com/dortania/OpenCore-Legacy-Patcher/"
  name "OpenCore Legacy Patcher"
  desc "Boot loader to inject/patch current features for unsupported Macs"
  homepage "https://dortania.github.io/OpenCore-Legacy-Patcher/"

  auto_updates true

  pkg "OpenCore-Patcher.pkg"

  uninstall launchctl: [
              "com.dortania.opencore-legacy-patcher.auto-patch",
              "com.dortania.opencore-legacy-patcher.macos-update",
            ],
            pkgutil:   "com.dortania.opencore-legacy-patcher",
            delete:    "/Applications/OpenCore-Patcher.app"

  zap trash: [
    "/Library/Logs/DiagnosticReports/OpenCore-Patcher_*.*_resource.diag",
    "/Users/Shared/.com.dortania.opencore-legacy-patcher.plist",
    "/Users/Shared/.OCLP-AutoPatcher-Log-*.txt",
    "/Users/Shared/.OCLP-System-Log-*.txt",
    "/Users/Shared/OpenCore-Patcher_*.log",
    "~/Library/Application Support/CrashReporter/OpenCore-Patcher*",
    "~/Library/Caches/com.dortania.opencore-legacy-patcher",
    "~/Library/Logs/Dortania",
    "~/Library/Preferences/com.dortania.opencore-legacy-patcher-wxpython.plist",
    "~/Library/Saved Application State/com.dortania.opencore-legacy-patcher-wxpython.savedState",
    "~/Library/Saved Application State/com.dortania.opencore-legacy-patcher.savedState",
    "~/Library/WebKit/com.dortania.opencore-legacy-patcher",
  ]
end
