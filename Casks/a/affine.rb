cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.20.5"
  sha256 arm:   "affbb4dd3a5711555351b26dbcf93bb9f3c17d1e162fc923ff1dd187195da3b9",
         intel: "27a7fe4ae8b63ade361985679395eea7461657903253230c2e4a9cfe4ef6cef7"

  url "https://mirror.ghproxy.com/https://github.com/toeverything/AFFiNE/releases/download/v#{version}/affine-#{version}-stable-macos-#{arch}.zip",
      verified: "github.com/toeverything/AFFiNE/"
  name "AFFiNE"
  desc "Note editor and whiteboard"
  homepage "https://affine.pro/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "AFFiNE.app"

  zap trash: [
    "~/Library/Application Support/AFFiNE",
    "~/Library/Logs/AFFiNE",
    "~/Library/Preferences/pro.affine.app.plist",
    "~/Library/Saved Application State/pro.affine.app.savedState",
  ]
end
