cask "iterm2-legacy" do
  # NOTE: "2" is not a version number, but indicates a different vendor
  version "2.1.4"
  sha256 "1062b83e7808dc1e13362f4a83ef770e1c24ea4ae090d1346b49f6196e9064cd"

  url "https://iterm2.com/downloads/stable/iTerm2-#{version.dots_to_underscores}.zip"
  name "iTerm2"
  desc "Terminal emulator as alternative to Apple's Terminal app"
  homepage "https://www.iterm2.com/"

  deprecate! date: "2023-12-17", because: :discontinued

  auto_updates true
  conflicts_with cask: [
    "iterm2",
    "iterm2-beta",
    "iterm2-nightly",
  ]

  app "iTerm.app"

  zap trash: "~/Library/Preferences/com.googlecode.iterm2.plist"
end
