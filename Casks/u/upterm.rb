cask "upterm" do
  version "0.4.4"
  sha256 "5394926add794e486172c72ef0dc04c225a481d2970f968522c0436ef42677ee"

  url "https://mirror.ghproxy.com/https://github.com/railsware/upterm/releases/download/v#{version}/upterm-#{version}-macOS.dmg"
  name "Upterm"
  desc "Terminal emulator for the 21st century"
  homepage "https://github.com/railsware/upterm"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Upterm.app"

  zap trash: [
    "~/.upterm",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.github.railsware.upterm.sfl*",
    "~/Library/Application Support/Upterm",
    "~/Library/Preferences/com.github.railsware.upterm.helper.plist",
    "~/Library/Preferences/com.github.railsware.upterm.plist",
    "~/Library/Saved Application State/com.github.railsware.upterm.savedState",
  ]
end
