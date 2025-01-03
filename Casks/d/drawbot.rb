cask "drawbot" do
  version "3.130"
  sha256 "9cb6bd3cb0061ad6e3e2cc3b78e58fddaa4d5a00dc6c3ab7a3fa08cb1ebebe97"

  url "https://mirror.ghproxy.com/https://github.com/typemytype/drawbot/releases/download/#{version}/DrawBot.dmg",
      verified: "github.com/typemytype/drawbot/"
  name "DrawBot"
  desc "Write Python scripts to generate two-dimensional graphics"
  homepage "https://www.drawbot.com/"

  app "DrawBot.app"

  zap trash: [
    "~/Library/Application Support/com.apple.sharedfilelist/com.apple.LSSharedFileList.ApplicationRecentDocuments/com.drawbot.sfl*",
    "~/Library/Preferences/com.drawbot.plist",
    "~/Library/Saved Application State/com.drawbot.savedState",
  ]

  caveats do
    requires_rosetta
  end
end
