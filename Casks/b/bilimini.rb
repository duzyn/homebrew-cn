cask "bilimini" do
  version "1.5.7"
  sha256 "d6c92362253c0d41cabd3440b2e72e25bb0da157d2bf87c7ef989e4ff28a1563"

  url "https://mirror.ghproxy.com/https://github.com/chitosai/bilimini/releases/download/v#{version}/bilimini-#{version}-mac.zip"
  name "bilimini"
  desc "Small window bilibili client"
  homepage "https://github.com/chitosai/bilimini"

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "bilimini.app"

  zap trash: [
    "~/Library/Application Support/bilimini",
    "~/Library/Preferences/com.electron.bilimini.plist",
    "~/Library/Saved Application State/com.electron.bilimini.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
