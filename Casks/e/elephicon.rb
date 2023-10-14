cask "elephicon" do
  arch arm: "arm64", intel: "x64"

  version "2.7.0"
  sha256 arm:   "68fb0acb83834a152b6b2d2884e0e506e6147a1837b95950a68004ac0e67d187",
         intel: "3a9fc132f5f0f48369c86685ae89ada692c89671d29a7011071ad5cb2124ef57"

  url "https://ghproxy.com/https://github.com/sprout2000/elephicon/releases/download/v#{version}/Elephicon-#{version}-darwin-#{arch}.dmg"
  name "Elephicon"
  desc "Create icns and ico files from png"
  homepage "https://github.com/sprout2000/elephicon/"

  auto_updates true

  app "Elephicon.app"

  zap trash: [
    "~/Library/Application Support/Elephicon",
    "~/Library/Caches/jp.wassabie64.Elephicon",
    "~/Library/Caches/jp.wassabie64.Elephicon.ShipIt",
    "~/Library/Logs/Elephicon",
    "~/Library/Preferences/jp.wassabie64.Elephicon.plist",
    "~/Library/Saved Application State/jp.wassabie64.Elephicon.savedState",
  ]
end