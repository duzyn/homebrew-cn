cask "audacity" do
  arch arm: "arm64", intel: "x86_64"

  version "3.5.0"
  sha256 arm:   "4d7d655ef19e5fa2591014282abe9075799a1d93b1dbe8f10131fe03e13da92b",
         intel: "34c42a6a017a175b75451dedac2b48f7f825772fe1bc6c04fe3f6dfcd51e82d8"

  url "https://mirror.ghproxy.com/https://github.com/audacity/audacity/releases/download/Audacity-#{version}/audacity-macOS-#{version}-#{arch}.dmg",
      verified: "github.com/audacity/audacity/"
  name "Audacity"
  desc "Multi-track audio editor and recorder"
  homepage "https://www.audacityteam.org/"

  livecheck do
    url :url
    regex(/^Audacity[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on macos: ">= :high_sierra"

  app "Audacity.app"

  zap trash: [
    "~/Library/Application Support/audacity",
    "~/Library/Preferences/org.audacityteam.audacity.plist",
    "~/Library/Saved Application State/org.audacityteam.audacity.savedState",
  ]
end
