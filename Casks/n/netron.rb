cask "netron" do
  version "7.9.0"
  sha256 "8f60f8a70a1966a3bda7cdcaaadf0bbaed71c360807e8cf191adf2c7408a1504"

  url "https://mirror.ghproxy.com/https://github.com/lutzroeder/netron/releases/download/v#{version}/Netron-#{version}-mac.zip"
  name "Netron"
  desc "Visualiser for neural network, deep learning, and machine learning models"
  homepage "https://github.com/lutzroeder/netron"

  auto_updates true

  app "Netron.app"

  zap trash: [
    "~/Library/Application Support/Netron",
    "~/Library/Preferences/com.lutzroeder.netron.plist",
    "~/Library/Saved Application State/com.lutzroeder.netron.savedState",
  ]
end
