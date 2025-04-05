cask "yaak@beta" do
  arch arm: "aarch64", intel: "x64"

  version "2025.2.0-beta.2"
  sha256 arm:   "969b0d0c44ffd7a2984b0d87b1f76108d24e11dfcc4fc10921987220dcc03386",
         intel: "d0636348274c07ea5261a61c91028cf23732388a12141581345e2c7e750ec71f"

  url "https://mirror.ghproxy.com/https://github.com/mountain-loop/yaak/releases/download/v#{version}/Yaak_#{version}_#{arch}.dmg",
      verified: "github.com/mountain-loop/yaak/"
  name "Yaak Beta"
  desc "REST, GraphQL and gRPC client"
  homepage "https://yaak.app/"

  livecheck do
    url :url
    regex(/^v?(\d+(?:\.\d+)+(?:[._-](?:beta|rc)[._-]\d+)?)$/i)
  end

  auto_updates true
  conflicts_with cask: "yaak"
  depends_on macos: ">= :ventura"

  app "yaak.app"

  zap trash: [
    "~/Library/Application Support/app.yaak.desktop",
    "~/Library/Caches/app.yaak.desktop",
    "~/Library/Logs/app.yaak.desktop",
    "~/Library/Saved Application State/app.yaak.desktop.savedState",
    "~/Library/Webkit/app.yaak.desktop",
  ]
end
