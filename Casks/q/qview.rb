cask "qview" do
  version "6.1"
  sha256 "e407b0f2fdd208ec72778feda0c34dcd12bc28420f9d5abd07e9287c1c91656a"

  url "https://mirror.ghproxy.com/https://github.com/jurplel/qView/releases/download/#{version}/qView-#{version}.dmg"
  name "qView"
  desc "Image viewer"
  homepage "https://github.com/jurplel/qView/"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "qView.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.interversehq.qview.sfl*",
    "~/Library/Preferences/com.interversehq.qView.plist",
    "~/Library/Preferences/com.qview.qView.plist",
    "~/Library/Saved Application State/com.interversehq.qView.savedState",
  ]
end
