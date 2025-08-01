cask "caret" do
  version "3.4.6"
  sha256 "a7d17bb7e9c938d8559f1569899a14413dae33bc4a7d4de038bf430447008aea"

  url "https://mirror.ghproxy.com/https://github.com/careteditor/issues/releases/download/#{version}/Caret.dmg",
      verified: "github.com/careteditor/issues/"
  name "Caret"
  homepage "https://caret.io/"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Caret.app"

  zap trash: [
    "~/Library/Application Support/Caret",
    "~/Library/Caches/io.caret",
    "~/Library/Caches/io.caret.ShipIt",
    "~/Library/Cookies/io.caret.binarycookies",
    "~/Library/Preferences/io.caret.helper.plist",
    "~/Library/Preferences/io.caret.plist",
    "~/Library/Saved Application State/io.caret.savedState",
  ]
end
