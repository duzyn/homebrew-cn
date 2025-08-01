cask "flipper" do
  arch arm: "aarch64", intel: "x64"

  version "0.273.0"
  sha256 arm:   "9b477dbae27651166b76a7ff06995c8da99ceece48ba12d0bdaf7e23e9b3eb53",
         intel: "4fb255b22728eeb7a670bf795686f767c16c988c586c656fbc6c37b8de896b42"

  url "https://mirror.ghproxy.com/https://github.com/facebook/flipper/releases/download/v#{version}/Flipper-server-mac-#{arch}.dmg",
      verified: "github.com/facebook/flipper/"
  name "Facebook Flipper"
  desc "Desktop debugging platform for mobile developers"
  homepage "https://fbflipper.com/"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-12-01", because: :discontinued

  app "Flipper.app"

  zap trash: [
    "~/.flipper",
    "~/Library/Application Support/Flipper",
    "~/Library/Preferences/rs.flipper-launcher",
  ]
end
