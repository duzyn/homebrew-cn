cask "netron" do
  version "7.8.4"
  sha256 "d967a3073687233fdb319ac30b1cd040c1d0473bac9e2657510befa9f70db415"

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
