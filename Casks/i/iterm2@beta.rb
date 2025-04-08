cask "iterm2@beta" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "3.5.13beta1"
  sha256 "0fa409b56033543fa46ecafcdf4f1b676029ea47f89a0f45cbb3c905c7bc31a9"

  url "https://iterm2.com/downloads/beta/iTerm2-#{version.dots_to_underscores}.zip"
  name "iTerm2"
  desc "Terminal emulator as alternative to Apple's Terminal app"
  homepage "https://iterm2.com/"

  livecheck do
    # workaround for
    # - https://github.com/Homebrew/homebrew-cask/pull/104019
    # - https://github.com/gnachman/iterm2-website/issues/82
    # url "https://iterm2.com/appcasts/testing_modern.xml"
    url "https://mirror.ghproxy.com/https://raw.githubusercontent.com/gnachman/iterm2-website/master/source/appcasts/testing_modern.xml"
    strategy :sparkle, &:version
  end

  auto_updates true
  conflicts_with cask: [
    "iterm2",
    "iterm2@nightly",
  ]
  depends_on macos: ">= :catalina"

  app "iTerm.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.googlecode.iterm2.sfl*",
    "~/Library/Application Support/iTerm",
    "~/Library/Application Support/iTerm2",
    "~/Library/Caches/com.googlecode.iterm2",
    "~/Library/Preferences/com.googlecode.iterm2.plist",
    "~/Library/Saved Application State/com.googlecode.iterm2.savedState",
  ]
end
