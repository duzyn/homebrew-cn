cask "folo@nightly" do
  arch arm: "arm64", intel: "x64"

  version "0.4.0"
  sha256 arm:   "5956704c159fb6231de38e56037a11fa395c297a65bab91a163bce947f52640a",
         intel: "86d9516f96de4135cc276721f92493ea65edd277a37476d7d543369b22d65cc0"

  url "https://mirror.ghproxy.com/https://github.com/RSSNext/Folo/releases/download/v#{version}/Folo-#{version}-macos-#{arch}.dmg",
      verified: "github.com/RSSNext/Folo/"
  name "Folo Nightly"
  desc "Information browser"
  homepage "https://follow.is/"

  livecheck do
    url :url
    regex(/^(?:nightly[._-])?v?(\d+(?:\.\d+)+(?:[._-]nightly[._-]?\d+)?)$/i)
  end

  conflicts_with cask: [
    "follow@alpha",
    "folo",
  ]
  depends_on macos: ">= :big_sur"

  app "Folo.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/is.follow.sfl*",
    "~/Library/Application Support/Folo",
    "~/Library/Logs/Folo",
    "~/Library/Preferences/is.follow.plist",
    "~/Library/Saved Application State/is.follow.savedState",
  ]
end
