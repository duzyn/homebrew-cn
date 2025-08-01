cask "bloomrpc" do
  version "1.5.3"
  sha256 "9ddc4d9b85af745a5f5e49a55e9dd4d57e09855aee721f77e2a3151744cbc3ad"

  url "https://mirror.ghproxy.com/https://github.com/uw-labs/bloomrpc/releases/download/#{version}/BloomRPC-#{version}.dmg"
  name "BloomRPC"
  desc "GUI Client for GRPC Services"
  homepage "https://github.com/uw-labs/bloomrpc"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "BloomRPC.app"

  zap trash: "~/Library/Preferences/io.github.utilitywarehouse.BloomRPC.plist"
end
