cask "archipelago" do
  version "6.0.6"
  sha256 "824b80a00ad81be4560527941e846bf251a28e3e966231b79243dbb8cd7868c2"

  url "https://mirror.ghproxy.com/https://github.com/npezza93/archipelago/releases/download/v#{version}/Archipelago.zip"
  name "Archipelago"
  desc "Terminal emulator built on web technology"
  homepage "https://github.com/npezza93/archipelago"

  depends_on macos: ">= :sonoma"

  app "Archipelago.app"

  zap trash: [
    "~/Library/Application Support/Archipelago",
    "~/Library/Caches/dev.archipelago",
    "~/Library/Caches/dev.archipelago.ShipIt",
    "~/Library/HTTPStorages/dev.archipelago",
    "~/Library/Preferences/dev.archipelago.plist",
    "~/Library/Saved Application State/dev.archipelago.savedState",
    "~/Library/WebKit/dev.archipelago",
  ]
end
