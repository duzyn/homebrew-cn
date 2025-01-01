cask "restfox" do
  arch arm: "arm64", intel: "x64"

  version "0.34.0"
  sha256 arm:   "eef487038bb2b33813d2ae1844c830026faa8dbbd6027758c9aef99e44c61ef4",
         intel: "5d2db18eda9aea4b582e0ba6c7e232e69b9589294c2e69b986611e85bf532823"

  url "https://mirror.ghproxy.com/https://github.com/flawiddsouza/Restfox/releases/download/v#{version}/Restfox-darwin-#{arch}-#{version}.zip",
      verified: "mirror.ghproxy.com/https://github.com/flawiddsouza/Restfox/releases/download/"
  name "Restfox"
  desc "Offline-first web HTTP client"
  homepage "https://restfox.dev/"

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Restfox.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.electron.restfox.sfl*",
    "~/Library/Application Support/Restfox",
    "~/Library/Caches/com.electron.restfox*",
    "~/Library/HTTPStorages/com.electron.restfox",
    "~/Library/Logs/Restfox",
    "~/Library/Preferences/ByHost/com.electron.restfox.*.plist",
    "~/Library/Preferences/com.electron.restfox.plist",
    "~/Library/Saved Application State/com.electron.restfox.savedState",
  ]
end
