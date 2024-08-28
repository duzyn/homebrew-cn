cask "kiwi-for-gmail" do
  version "4.2.6"
  sha256 "a36504f578327acc1712965c61335ef534f3b5bac3a34809313fe71db207454c"

  url "https://downloads.kiwiforgmail.com/kiwi/release/consumer/Kiwi%20for%20Gmail-#{version}-universal-mac.zip"
  name "Kiwi for Gmail"
  desc "Enhances Gmail like a full-featured desktop office productivity app"
  homepage "https://www.kiwiforgmail.com/"

  livecheck do
    url "https://downloads.kiwiforgmail.com/kiwi/release/consumer/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Kiwi for Gmail.app"

  zap trash: [
    "~/Library/Application Scripts/com.zive.kiwi",
    "~/Library/Application Scripts/com.zive.kiwi.loginhelper",
    "~/Library/Application Scripts/com.zive.kiwi.share",
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.zive.kiwi.sfl*",
    "~/Library/Application Support/Kiwi for Gmail",
    "~/Library/Containers/com.zive.kiwi",
    "~/Library/Containers/com.zive.kiwi.loginhelper",
    "~/Library/Containers/com.zive.kiwi.share",
    "~/Library/Group Containers/ND86S98S6P.com.zive.kiwi",
    "~/Library/Preferences/com.zive.kiwi.plist",
    "~/Library/Saved Application State/com.zive.kiwi.savedState",
  ]
end
