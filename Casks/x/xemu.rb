cask "xemu" do
  version "0.8.10"
  sha256 "cdae8d058bca287d6638a9a728a6b0ec611605daa60376b8ad13aa8498502a9d"

  url "https://mirror.ghproxy.com/https://github.com/xemu-project/xemu/releases/download/v#{version}/xemu-macos-universal-release.zip",
      verified: "github.com/xemu-project/xemu/"
  name "Xemu"
  desc "Original Xbox Emulator"
  homepage "https://xemu.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Xemu.app"

  zap trash: [
    "~/Library/Application Support/xemu",
    "~/Library/Preferences/xemu.app.0.plist",
    "~/Library/Saved Application State/xemu.app.0.savedState",
  ]
end
