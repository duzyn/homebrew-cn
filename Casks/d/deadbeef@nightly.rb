cask "deadbeef@nightly" do
  version :latest
  sha256 :no_check

  url "https://downloads.sourceforge.net/deadbeef/travis/macOS/master/deadbeef-devel-macos-universal.zip?use_mirror=jaist",
      verified: "downloads.sourceforge.net/deadbeef/?use_mirror=jaist"
  name "DeaDBeeF"
  desc "Modular audio player"
  homepage "https://deadbeef.sourceforge.io/"

  deprecate! date: "2025-05-01", because: :unsigned

  depends_on macos: ">= :high_sierra"

  app "DeaDBeeF.app"

  zap trash: [
    "~/Library/Preferences/com.deadbeef.deadbeef.plist",
    "~/Library/Preferences/deadbeef",
    "~/Library/Saved Application State/com.deadbeef.deadbeef.savedState",
  ]
end
